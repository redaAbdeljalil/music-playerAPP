import Foundation

struct SearchResults {
    var tracks: [Track] = []
    var artists: [Artist] = []
    var albums: [Album] = []
    var playlists: [Playlist] = []

    var isEmpty: Bool {
        tracks.isEmpty && artists.isEmpty && albums.isEmpty && playlists.isEmpty
    }
}


protocol MusicLibraryProviding {
    func allTracks() -> [Track]
    func allArtists() -> [Artist]
    func allAlbums() -> [Album]
    func allPlaylists() -> [Playlist]
    func allMoods() -> [Mood]

    func tracks(forMood moodID: String) -> [Track]
    func tracks(forAlbum albumID: String) -> [Track]
    func tracks(forPlaylist playlistID: String) -> [Track]
    func track(byID id: String) -> Track?

    func search(query: String) -> SearchResults
}

final class MockMusicLibraryService: MusicLibraryProviding {

    func allTracks() -> [Track] { MockMusicData.tracks }
    func allArtists() -> [Artist] { MockMusicData.artists }
    func allAlbums() -> [Album] { MockMusicData.albums }
    func allPlaylists() -> [Playlist] { MockMusicData.playlists }
    func allMoods() -> [Mood] { MockMusicData.moods }

    func tracks(forMood moodID: String) -> [Track] {
        MockMusicData.tracks.filter { $0.moodIDs.contains(moodID) }
    }

    func tracks(forAlbum albumID: String) -> [Track] {
        MockMusicData.tracks.filter { $0.albumID == albumID }
    }

    func tracks(forPlaylist playlistID: String) -> [Track] {
        guard let playlist = MockMusicData.playlists.first(where: { $0.id == playlistID }) else {
            return []
        }
        return playlist.trackIDs.compactMap { id in
            MockMusicData.tracks.first(where: { $0.id == id })
        }
    }

    func track(byID id: String) -> Track? {
        MockMusicData.tracks.first(where: { $0.id == id })
    }

    func search(query: String) -> SearchResults {
        let normalized = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !normalized.isEmpty else { return SearchResults() }

        var results = SearchResults()
        results.tracks = MockMusicData.tracks.filter {
            $0.title.lowercased().contains(normalized) || $0.artistName.lowercased().contains(normalized)
        }
        results.artists = MockMusicData.artists.filter {
            $0.name.lowercased().contains(normalized)
        }
        results.albums = MockMusicData.albums.filter {
            $0.title.lowercased().contains(normalized) || $0.artistName.lowercased().contains(normalized)
        }
        results.playlists = MockMusicData.playlists.filter {
            $0.title.lowercased().contains(normalized)
        }
        return results
    }
}
