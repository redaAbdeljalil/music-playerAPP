import Foundation
import Combine

@MainActor
final class DiscoverViewModel: ObservableObject {
    @Published private(set) var moods: [Mood] = []

    private let library: MusicLibraryProviding

    init(library: MusicLibraryProviding = MockMusicLibraryService()) {
        self.library = library
        self.moods = library.allMoods()
    }

    func tracks(for mood: Mood) -> [Track] {
        library.tracks(forMood: mood.id)
    }
}
