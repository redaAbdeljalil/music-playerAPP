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
    func tracks(forArtist artistID: String) -> [Track]
    func track(byID id: String) -> Track?

    func artist(byID id: String) -> Artist?
    func album(byID id: String) -> Album?
    func albums(forArtist artistID: String) -> [Album]

    func search(query: String) -> SearchResults
}

/// Backed by MusicCatalog — real artists, albums, and tracks. See Models/Catalog/MusicCatalog.swift
/// for the data itself; this type is just the query surface the app's views/view models talk to.
final class CatalogMusicLibraryService: MusicLibraryProviding {

    func allTracks() -> [Track] { MusicCatalog.tracks }
    func allArtists() -> [Artist] { MusicCatalog.artists }
    func allAlbums() -> [Album] { MusicCatalog.albums }
    func allPlaylists() -> [Playlist] { MusicCatalog.playlists }
    func allMoods() -> [Mood] { MusicCatalog.moods }

    func tracks(forMood moodID: String) -> [Track] {
        MusicCatalog.tracks.filter { $0.moodIDs.contains(moodID) }
    }

    func tracks(forAlbum albumID: String) -> [Track] {
        MusicCatalog.tracks
            .filter { $0.albumID == albumID }
            .sorted { $0.trackNumber < $1.trackNumber }
    }

    func tracks(forPlaylist playlistID: String) -> [Track] {
        guard let playlist = MusicCatalog.playlists.first(where: { $0.id == playlistID }) else {
            return []
        }
        return playlist.trackIDs.compactMap { id in
            MusicCatalog.tracks.first(where: { $0.id == id })
        }
    }

    func tracks(forArtist artistID: String) -> [Track] {
        MusicCatalog.tracks.filter { $0.artistID == artistID }
    }

    func track(byID id: String) -> Track? {
        MusicCatalog.tracks.first(where: { $0.id == id })
    }

    func artist(byID id: String) -> Artist? {
        MusicCatalog.artists.first(where: { $0.id == id })
    }

    func album(byID id: String) -> Album? {
        MusicCatalog.albums.first(where: { $0.id == id })
    }

    func albums(forArtist artistID: String) -> [Album] {
        MusicCatalog.albums
            .filter { $0.artistID == artistID }
            .sorted { $0.year < $1.year }
    }

    func search(query: String) -> SearchResults {
        let normalized = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !normalized.isEmpty else { return SearchResults() }

        var results = SearchResults()
        results.tracks = MusicCatalog.tracks.filter {
            $0.title.lowercased().contains(normalized) || $0.artistName.lowercased().contains(normalized)
        }
        results.artists = MusicCatalog.artists.filter {
            $0.name.lowercased().contains(normalized)
        }
        results.albums = MusicCatalog.albums.filter {
            $0.title.lowercased().contains(normalized) || $0.artistName.lowercased().contains(normalized)
        }
        results.playlists = MusicCatalog.playlists.filter {
            $0.title.lowercased().contains(normalized)
        }
        return results
    }
}
