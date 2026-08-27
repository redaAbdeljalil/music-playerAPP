import Foundation

struct Artist: Identifiable, Hashable {
    let id: String
    /// Stable, filename-safe handle used to derive catalog + asset + audio names ("the_weeknd").
    let slug: String
    let name: String
    let bio: String
    /// Short editorial genre tag, e.g. "Rap · Raï".
    let genreLabel: String
    /// Short editorial origin tag, e.g. "Algeria".
    let originLabel: String
    /// Looked up in Resources/Artists/<imageAssetName>.(jpg|jpeg|png|heic); falls back to generated art.
    let imageAssetName: String
    /// Hex color (no #) used to tint this artist's atmosphere — Now Playing, Artist/Album detail.
    let accentColorHex: String
}

struct Album: Identifiable, Hashable {
    let id: String
    let title: String
    let artistID: String
    /// Denormalized for cheap list-row display; always derived from the owning Artist at catalog build time.
    let artistName: String
    let year: Int
    let genre: Genre
    /// Looked up in Resources/Albums/<artworkAssetName>.(jpg|jpeg|png|heic); falls back to generated art.
    let artworkAssetName: String
}

struct Track: Identifiable, Hashable {
    let id: String
    let title: String
    let artistID: String
    let artistName: String
    let albumID: String
    let albumTitle: String
    let trackNumber: Int
    let duration: TimeInterval
    let artworkAssetName: String
    /// Looked up in Resources/Audio/<audioFileName>.(mp3|m4a|wav|aac); falls back to a bundled sample clip.
    let audioFileName: String
    let moodIDs: [String]
    let genre: Genre
}

struct Playlist: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let trackIDs: [String]
    let artworkSeed: String
    let imageAssetName: String?
}

struct Mood: Identifiable, Hashable {
    let id: String
    let name: String
    let descriptor: String
    let artworkSeed: String
    let imageAssetName: String?
}

enum Genre: String, CaseIterable, Hashable {
    case rap, hipHop, rnb, pop, soul

    var displayName: String {
        switch self {
        case .rap: return "Rap"
        case .hipHop: return "Hip-Hop"
        case .rnb: return "R&B"
        case .pop: return "Pop"
        case .soul: return "Soul"
        }
    }
}
