import Foundation
import Combine

@MainActor
final class LibraryViewModel: ObservableObject {
    @Published private(set) var playlists: [Playlist] = []

    private let library: MusicLibraryProviding

    init(library: MusicLibraryProviding = CatalogMusicLibraryService()) {
        self.library = library
        self.playlists = library.allPlaylists()
    }

    func tracks(for playlist: Playlist) -> [Track] {
        library.tracks(forPlaylist: playlist.id)
    }
}
