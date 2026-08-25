import Foundation

enum AURATab: CaseIterable {
    case home, discover, search, library

    var title: String {
        switch self {
        case .home: return "Home"
        case .discover: return "Discover"
        case .search: return "Search"
        case .library: return "Library"
        }
    }

    var icon: String {
        switch self {
        case .home: return AURAIcon.home
        case .discover: return AURAIcon.discover
        case .search: return AURAIcon.search
        case .library: return AURAIcon.library
        }
    }
}
