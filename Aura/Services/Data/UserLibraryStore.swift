import Foundation
import Combine


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

    func seedDefaults(likedTracks: [Track], savedAlbums: [Album]) {
        guard !didSeedDefaults else { return }
        didSeedDefaults = true
        self.likedTracks = likedTracks
        self.savedAlbums = savedAlbums
    }
}
