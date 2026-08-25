import Foundation
import Combine

enum RepeatMode {
    case off, all, one

    mutating func cycle() {
        switch self {
        case .off: self = .all
        case .all: self = .one
        case .one: self = .off
        }
    }
}

/// The single source of truth for "what's playing right now." Owns the
/// queue, current index, shuffle order, and repeat mode, and delegates
/// the actual decoding/output to an `AudioEngine`. Every screen that
/// needs playback state (mini player, Now Playing, track rows showing
/// an active indicator) reads this via `@EnvironmentObject`.
@MainActor
final class PlaybackManager: ObservableObject {
    @Published private(set) var currentTrack: Track?
    @Published private(set) var queue: [Track] = []
    @Published private(set) var isPlaying: Bool = false
    @Published private(set) var progress: TimeInterval = 0
    @Published private(set) var duration: TimeInterval = 0
    @Published var shuffleEnabled: Bool = false {
        didSet { rebuildPlaybackOrderIfNeeded() }
    }
    @Published var repeatMode: RepeatMode = .off

    /// Composition-root hook: RootView wires this to `UserLibraryStore.recordPlay`
    /// so this type never needs to know that store exists.
    var onTrackDidStart: ((Track) -> Void)?

    private let engine: AudioEngine
    private var currentIndex: Int = 0
    private var playbackOrder: [Int] = []
    private var orderCursor: Int = 0

    init(engine: AudioEngine = AudioPlayerService()) {
        self.engine = engine
        engine.onFinish = { [weak self] in
            self?.handleTrackFinished()
        }
        engine.onTimeUpdate = { [weak self] time, duration in
            self?.progress = time
            self?.duration = duration
        }
    }

    func play(track: Track, in newQueue: [Track]) {
        queue = newQueue.isEmpty ? [track] : newQueue
        currentIndex = queue.firstIndex(where: { $0.id == track.id }) ?? 0
        buildPlaybackOrder(startingAt: currentIndex)
        loadAndPlayCurrent()
    }

    func togglePlayPause() {
        guard currentTrack != nil else { return }
        if isPlaying {
            engine.pause()
        } else {
            engine.play()
        }
        isPlaying.toggle()
    }

    func skipNext() {
        guard !queue.isEmpty else { return }
        advanceOrder(by: 1)
        loadAndPlayCurrent()
    }

    func skipPrevious() {
        guard !queue.isEmpty else { return }
        if progress > 3 {
            seek(to: 0)
            return
        }
        advanceOrder(by: -1)
        loadAndPlayCurrent()
    }

    func seek(to time: TimeInterval) {
        engine.seek(to: time)
        progress = time
    }

    func toggleShuffle() {
        shuffleEnabled.toggle()
    }

    func cycleRepeatMode() {
        repeatMode.cycle()
    }

    func isCurrentTrack(_ track: Track) -> Bool {
        currentTrack?.id == track.id
    }

    // MARK: - Private

    private func handleTrackFinished() {
        switch repeatMode {
        case .one:
            loadAndPlayCurrent()
        case .all:
            advanceOrder(by: 1)
            loadAndPlayCurrent()
        case .off:
            if orderCursor < playbackOrder.count - 1 {
                advanceOrder(by: 1)
                loadAndPlayCurrent()
            } else {
                isPlaying = false
                progress = 0
            }
        }
    }

    private func buildPlaybackOrder(startingAt index: Int) {
        var indices = Array(queue.indices)
        if shuffleEnabled {
            indices.shuffle()
            if let position = indices.firstIndex(of: index) {
                indices.swapAt(0, position)
            }
            playbackOrder = indices
            orderCursor = 0
        } else {
            playbackOrder = indices
            orderCursor = index
        }
    }

    private func rebuildPlaybackOrderIfNeeded() {
        guard !queue.isEmpty else { return }
        buildPlaybackOrder(startingAt: currentIndex)
    }

    private func advanceOrder(by delta: Int) {
        guard !playbackOrder.isEmpty else { return }
        var next = orderCursor + delta
        if next < 0 { next = playbackOrder.count - 1 }
        if next >= playbackOrder.count { next = 0 }
        orderCursor = next
        currentIndex = playbackOrder[orderCursor]
    }

    private func loadAndPlayCurrent() {
        guard queue.indices.contains(currentIndex) else { return }
        let track = queue[currentIndex]
        currentTrack = track
        progress = 0
        if engine.load(fileName: track.audioFileName) {
            engine.play()
            isPlaying = true
            onTrackDidStart?(track)
        } else {
            isPlaying = false
        }
    }
}
