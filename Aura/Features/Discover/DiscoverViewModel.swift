import Foundation
import Combine

@MainActor
final class DiscoverViewModel: ObservableObject {
    @Published private(set) var moods: [Mood] = []
    @Published private(set) var featuredMood: Mood?

    private let library: MusicLibraryProviding

    init(library: MusicLibraryProviding = CatalogMusicLibraryService()) {
        self.library = library
        let allMoods = library.allMoods()
        if !allMoods.isEmpty {
            let dayIndex = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
            self.featuredMood = allMoods[dayIndex % allMoods.count]
        }
        self.moods = allMoods.filter { $0.id != featuredMood?.id }
    }

    func tracks(for mood: Mood) -> [Track] {
        library.tracks(forMood: mood.id)
    }
}
