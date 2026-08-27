import Foundation

/// Real catalog data for Taylor Swift.
/// Add another artist by creating a file like this one, then registering it in MusicCatalog.swift.
enum TaylorSwiftCatalog {

    static let artist = Artist(
        id: "artist_taylor_swift",
        slug: "taylor_swift",
        name: "Taylor Swift",
        bio: "One of pop's defining songwriters, moving fluidly from country roots to synth-pop spectacle to confessional folk.",
        genreLabel: "Pop",
        originLabel: "Pennsylvania, USA",
        imageAssetName: "artist_taylor_swift",
        accentColorHex: "A65C6D"
    )

    private static let album_1989 = Album(
        id: "album_taylor_swift_1989",
        title: "1989",
        artistID: artist.id,
        artistName: artist.name,
        year: 2014,
        genre: .pop,
        artworkAssetName: "album_taylor_swift_1989"
    )

    private static let album_1989Tracks: [Track] = MusicCatalog.makeTracks(
        album: album_1989,
        artist: artist,
        entries: [
            ("Welcome to New York", 212),
            ("Blank Space", 231),
            ("Style", 231),
            ("Out of the Woods", 235),
            ("All You Had to Do Was Stay", 193),
            ("Shake It Off", 219),
            ("I Wish You Would", 207),
            ("Bad Blood", 211),
            ("Wildest Dreams", 220),
            ("How You Get the Girl", 250),
            ("This Love", 250),
            ("I Know Places", 195),
            ("Clean", 271),
        ]
    )

    private static let album_folklore = Album(
        id: "album_taylor_swift_folklore",
        title: "Folklore",
        artistID: artist.id,
        artistName: artist.name,
        year: 2020,
        genre: .pop,
        artworkAssetName: "album_taylor_swift_folklore"
    )

    private static let album_folkloreTracks: [Track] = MusicCatalog.makeTracks(
        album: album_folklore,
        artist: artist,
        entries: [
            ("the 1", 209),
            ("cardigan", 239),
            ("the last great american dynasty", 231),
            ("exile", 285),
            ("my tears ricochet", 255),
            ("mirrorball", 228),
            ("seven", 207),
            ("august", 261),
            ("this is me trying", 195),
            ("illicit affairs", 190),
            ("invisible string", 252),
            ("mad woman", 237),
            ("epiphany", 289),
            ("betty", 293),
        ]
    )

    private static let album_midnights = Album(
        id: "album_taylor_swift_midnights",
        title: "Midnights",
        artistID: artist.id,
        artistName: artist.name,
        year: 2022,
        genre: .pop,
        artworkAssetName: "album_taylor_swift_midnights"
    )

    private static let album_midnightsTracks: [Track] = MusicCatalog.makeTracks(
        album: album_midnights,
        artist: artist,
        entries: [
            ("Lavender Haze", 202),
            ("Maroon", 218),
            ("Anti-Hero", 200),
            ("Snow on the Beach", 256),
            ("You're on Your Own, Kid", 196),
            ("Midnight Rain", 174),
            ("Question...?", 210),
            ("Vigilante Shit", 164),
            ("Bejeweled", 194),
            ("Labyrinth", 247),
            ("Karma", 204),
            ("Sweet Nothing", 189),
            ("Mastermind", 192),
        ]
    )

    static let albums: [Album] = [album_1989, album_folklore, album_midnights]
    static let tracks: [Track] = album_1989Tracks + album_folkloreTracks + album_midnightsTracks
}
