import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published private(set) var results: SearchResults = SearchResults()
    @Published private(set) var recentSearches: [String] = []
    let trendingSearches: [String]

    private let library: MusicLibraryProviding
    private let maxRecents = 6

    init(library: MusicLibraryProviding = CatalogMusicLibraryService()) {
        self.library = library
        let moodNames = library.allMoods().prefix(3).map { $0.name }
        let artistNames = library.allArtists().prefix(2).map { $0.name }
        self.trendingSearches = moodNames + artistNames
    }

    func performSearch() {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        results = library.search(query: trimmed)
        if !trimmed.isEmpty {
            recordRecent(trimmed)
        }
    }

    func selectSuggestion(_ text: String) {
        query = text
        performSearch()
    }

    func clearQuery() {
        query = ""
        results = SearchResults()
    }

    private func recordRecent(_ text: String) {
        recentSearches.removeAll { $0.caseInsensitiveCompare(text) == .orderedSame }
        recentSearches.insert(text, at: 0)
        if recentSearches.count > maxRecents {
            recentSearches.removeLast(recentSearches.count - maxRecents)
        }
    }
}
