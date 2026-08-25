import Foundation

struct Artist: Identifiable, Hashable {
    let id: String
    let name: String
    let bio: String
}

struct Album: Identifiable, Hashable {
    let id: String
    let title: String
    let artistName: String
    let year: Int
    let artworkSeed: String
}

/// Backing genre taxonomy. Not every case is necessarily represented in
/// the mock catalog — the enum exists so the data layer (and eventually
/// a real API) has somewhere to grow into.
enum Genre: String, CaseIterable, Hashable {
    case ambient, electronic, soul, jazz, indie, lofi, classical, experimental

    var displayName: String {
        rawValue.prefix(1).uppercased() + rawValue.dropFirst()
    }
}

struct Track: Identifiable, Hashable {
    let id: String
    let title: String
    let artistName: String
    let albumID: String
    let albumTitle: String
    let duration: TimeInterval
    /// Seed for the procedurally generated artwork (see `ArtworkView`).
    let artworkSeed: String
    /// Filename (without extension) of the bundled audio resource.
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
}

struct Mood: Identifiable, Hashable {
    let id: String
    let name: String
    let descriptor: String
    let artworkSeed: String
}
