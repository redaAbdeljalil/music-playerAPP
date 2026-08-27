import Foundation
import AVFoundation


protocol AudioEngine: AnyObject {
    var onFinish: (() -> Void)? { get set }
    var onTimeUpdate: ((TimeInterval, TimeInterval) -> Void)? { get set }

    @discardableResult
    func load(fileName: String) -> Bool
    func play()
    func pause()
    func seek(to time: TimeInterval)
}

final class AudioPlayerService: NSObject, AudioEngine {

    var onFinish: (() -> Void)?
    var onTimeUpdate: ((TimeInterval, TimeInterval) -> Void)?

    private var player: AVAudioPlayer?
    private var progressTimer: Timer?

    /// Tried in order, so a plain resource name resolves regardless of which format gets added.
    private static let audioExtensions = ["mp3", "m4a", "wav", "aac"]
    /// Tried in order: an "Audio" subdirectory first, then the bundle root — covers both possible
    /// outcomes of adding files via Xcode's synchronized folders without requiring either one.
    private static let audioDirectories: [String?] = ["Audio", nil]
    private static let sampleClipCount = 6

    override init() {
        super.init()
        configureAudioSession()
    }

    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [])
            try session.setActive(true)
        } catch {
            print("AURA: failed to configure audio session — \(error.localizedDescription)")
        }
    }

    @discardableResult
    func load(fileName: String) -> Bool {
        stopTimer()
        if let url = Self.resolveURL(fileName) {
            return loadPlayer(from: url)
        }
        // Real audio for this track hasn't been added yet — fall back to a bundled sample clip so
        // every row in the app stays genuinely playable end-to-end. Drop the real file into
        // Resources/Audio (matching MEDIA_CHECKLIST.md) to replace it; nothing else needs to change.
        let fallbackName = Self.fallbackSampleName(for: fileName)
        guard let fallbackURL = Self.resolveURL(fallbackName) else {
            print("AURA: no audio found for \"\(fileName)\", and the bundled sample clips are missing too.")
            player = nil
            return false
        }
        print("AURA: \"\(fileName)\" not found in Resources/Audio — using placeholder sample \"\(fallbackName)\" instead.")
        return loadPlayer(from: fallbackURL)
    }

    func play() {
        player?.play()
        startTimer()
    }

    func pause() {
        player?.pause()
        stopTimer()
    }

    func seek(to time: TimeInterval) {
        guard let player else { return }
        let clamped = max(0, min(time, player.duration))
        player.currentTime = clamped
        onTimeUpdate?(clamped, player.duration)
    }

    // MARK: - Private

    private func loadPlayer(from url: URL) -> Bool {
        do {
            let newPlayer = try AVAudioPlayer(contentsOf: url)
            newPlayer.delegate = self
            newPlayer.prepareToPlay()
            player = newPlayer
            return true
        } catch {
            print("AURA: failed to load \(url.lastPathComponent) — \(error.localizedDescription)")
            player = nil
            return false
        }
    }

    private static func resolveURL(_ fileName: String) -> URL? {
        for directory in audioDirectories {
            for ext in audioExtensions {
                if let url = Bundle.main.url(forResource: fileName, withExtension: ext, subdirectory: directory) {
                    return url
                }
            }
        }
        return nil
    }

    /// Deterministic so a given track always falls back to the same sample clip rather than a
    /// different one each launch.
    private static func fallbackSampleName(for fileName: String) -> String {
        var hash = 5381
        for scalar in fileName.unicodeScalars {
            hash = ((hash << 5) &+ hash) &+ Int(scalar.value)
        }
        let index = (abs(hash) % sampleClipCount) + 1
        return "aura_sample_\(index)"
    }

    private func startTimer() {
        stopTimer()
        let timer = Timer(timeInterval: 0.25, repeats: true) { [weak self] _ in
            guard let self, let player = self.player else { return }
            self.onTimeUpdate?(player.currentTime, player.duration)
        }
        RunLoop.main.add(timer, forMode: .common)
        progressTimer = timer
    }

    private func stopTimer() {
        progressTimer?.invalidate()
        progressTimer = nil
    }
}

extension AudioPlayerService: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopTimer()
        onFinish?()
    }
}
