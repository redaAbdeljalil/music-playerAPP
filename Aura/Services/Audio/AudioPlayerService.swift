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
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "wav") else {
            print("AURA: missing audio resource \(fileName).wav — add it to the app target (see README).")
            player = nil
            return false
        }
        do {
            let newPlayer = try AVAudioPlayer(contentsOf: url)
            newPlayer.delegate = self
            newPlayer.prepareToPlay()
            player = newPlayer
            return true
        } catch {
            print("AURA: failed to load \(fileName) — \(error.localizedDescription)")
            player = nil
            return false
        }
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
