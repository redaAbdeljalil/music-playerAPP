import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var featured: Track?
    @Published private(set) var curated: [Track] = []
    @Published private(set) var moods: [Mood] = []
    @Published private(set) var recommendedArtists: [Artist] = []

    private let library: MusicLibraryProviding

    init(library: MusicLibraryProviding = MockMusicLibraryService()) {
        self.library = library
        let allTracks = library.allTracks()
        self.featured = allTracks.first
        self.curated = Array(allTracks.dropFirst().prefix(8))
        self.moods = Array(library.allMoods().prefix(6))
        self.recommendedArtists = library.allArtists()
    }

    var greeting: String {
        switch Calendar.current.component(.hour, from: Date()) {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<22: return "Good evening"
        default: return "Late night"
        }
    }
}
