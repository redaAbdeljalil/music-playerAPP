import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var featured: Track?
    @Published private(set) var rotation: [Track] = []
    @Published private(set) var exploreAlbums: [Album] = []
    @Published private(set) var moods: [Mood] = []
    @Published private(set) var recommendedArtists: [Artist] = []

    private let library: MusicLibraryProviding

    init(library: MusicLibraryProviding = CatalogMusicLibraryService()) {
        self.library = library
        let artists = library.allArtists()
        self.recommendedArtists = artists

        // One representative track per artist — each one's own opening track, so the pick always
        // reads as intentional rather than "whatever happened to be first in the array."
        let spotlightPool: [Track] = artists.compactMap { library.tracks(forArtist: $0.id).first }
        if !spotlightPool.isEmpty {
            let dayIndex = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
            self.featured = spotlightPool[dayIndex % spotlightPool.count]
        }

        // A second track per artist, so "This week" spans the catalog instead of reading like one
        // artist's tracklist.
        let rotationPool: [Track] = artists.compactMap { artist in
            library.tracks(forArtist: artist.id).dropFirst().first
        }
        self.rotation = Array(rotationPool.filter { $0.id != featured?.id }.prefix(6))

        // Each artist's most recent release.
        self.exploreAlbums = artists.compactMap { library.albums(forArtist: $0.id).last }

        self.moods = Array(library.allMoods().prefix(6))
    }

    var greeting: String {
        switch Calendar.current.component(.hour, from: Date()) {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<22: return "Good evening"
        default: return "Late night"
        }
    }

    func accentHex(forArtistID artistID: String) -> String? {
        recommendedArtists.first(where: { $0.id == artistID })?.accentColorHex
    }
}
