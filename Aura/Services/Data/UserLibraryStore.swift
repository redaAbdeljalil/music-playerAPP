import Foundation
import Combine

/// Holds the user's own relationship to the catalog — likes, play
/// history, saved albums. Deliberately separate from
/// `MusicLibraryProviding` (which is the read-only catalog): this is
/// mutable, per-user state, in-memory for the MVP but structured so it
/// could be backed by persistence (UserDefaults/SwiftData) later without
/// changing any call site.
@MainActor
final class UserLibraryStore: ObservableObject {
    @Published private(set) var likedTracks: [Track] = []
    @Published private(set) var recentlyPlayed: [Track] = []
    @Published private(set) var savedAlbums: [Album] = []

    private let maxRecents = 12
    private var didSeedDefaults = false

    func isLiked(_ track: Track) -> Bool {
        likedTracks.contains { $0.id == track.id }
    }

    func toggleLike(_ track: Track) {
        if let index = likedTracks.firstIndex(where: { $0.id == track.id }) {
            likedTracks.remove(at: index)
        } else {
            likedTracks.insert(track, at: 0)
        }
    }

    func recordPlay(_ track: Track) {
        recentlyPlayed.removeAll { $0.id == track.id }
        recentlyPlayed.insert(track, at: 0)
        if recentlyPlayed.count > maxRecents {
            recentlyPlayed.removeLast(recentlyPlayed.count - maxRecents)
        }
    }

    /// Pre-populates a little content so Library isn't a dead end on
    /// first launch. Safe to call more than once (e.g. from `onAppear`
    /// firing again) — only takes effect the first time.
    func seedDefaults(likedTracks: [Track], savedAlbums: [Album]) {
        guard !didSeedDefaults else { return }
        didSeedDefaults = true
        self.likedTracks = likedTracks
        self.savedAlbums = savedAlbums
    }
}
