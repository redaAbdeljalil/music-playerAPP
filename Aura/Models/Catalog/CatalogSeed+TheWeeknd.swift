import Foundation

/// Real catalog data for The Weeknd.
/// Add another artist by creating a file like this one, then registering it in MusicCatalog.swift.
enum TheWeekndCatalog {

    static let artist = Artist(
        id: "artist_the_weeknd",
        slug: "the_weeknd",
        name: "The Weeknd",
        bio: "Toronto-born R&B auteur behind the moody, neon-lit world of After Hours and Dawn FM.",
        genreLabel: "R&B · Pop",
        originLabel: "Toronto, Canada",
        imageAssetName: "artist_the_weeknd",
        accentColorHex: "8B2635"
    )

    private static let album_starboy = Album(
        id: "album_the_weeknd_starboy",
        title: "Starboy",
        artistID: artist.id,
        artistName: artist.name,
        year: 2016,
        genre: .rnb,
        artworkAssetName: "album_the_weeknd_starboy"
    )

    private static let album_starboyTracks: [Track] = MusicCatalog.makeTracks(
        album: album_starboy,
        artist: artist,
        entries: [
            ("Starboy", 230),
            ("Party Monster", 249),
            ("False Alarm", 220),
            ("Reminder", 221),
            ("Rockin'", 236),
            ("Secrets", 266),
            ("True Colors", 215),
            ("Stargirl Interlude", 112),
            ("Sidewalks", 203),
            ("Six Feet Under", 213),
            ("A Lonely Night", 216),
            ("Attention", 190),
            ("Ordinary Life", 212),
            ("I Feel It Coming", 269),
        ]
    )

    private static let album_after_hours = Album(
        id: "album_the_weeknd_after_hours",
        title: "After Hours",
        artistID: artist.id,
        artistName: artist.name,
        year: 2020,
        genre: .rnb,
        artworkAssetName: "album_the_weeknd_after_hours"
    )

    private static let album_after_hoursTracks: [Track] = MusicCatalog.makeTracks(
        album: album_after_hours,
        artist: artist,
        entries: [
            ("Alone Again", 250),
            ("Too Late", 240),
            ("Hardest to Love", 211),
            ("Scared to Live", 212),
            ("Snowchild", 258),
            ("Escape from LA", 356),
            ("Heartless", 198),
            ("Faith", 283),
            ("Blinding Lights", 200),
            ("In Your Eyes", 238),
            ("Save Your Tears", 217),
            ("Repeat After Me (Interlude)", 195),
            ("After Hours", 361),
            ("Until I Bleed Out", 192),
        ]
    )

    private static let album_dawn_fm = Album(
        id: "album_the_weeknd_dawn_fm",
        title: "Dawn FM",
        artistID: artist.id,
        artistName: artist.name,
        year: 2022,
        genre: .rnb,
        artworkAssetName: "album_the_weeknd_dawn_fm"
    )

    private static let album_dawn_fmTracks: [Track] = MusicCatalog.makeTracks(
        album: album_dawn_fm,
        artist: artist,
        entries: [
            ("Dawn FM", 92),
            ("Gasoline", 213),
            ("How Do I Make You Love Me?", 219),
            ("Take My Breath", 224),
            ("Sacrifice", 188),
            ("Out of Time", 214),
            ("Here We Go... Again", 251),
            ("Best Friends", 200),
            ("Is There Someone Else?", 203),
            ("Starry Eyes", 232),
            ("Don't Break My Heart", 215),
            ("I Heard You're Married", 273),
            ("Less Than Zero", 218),
        ]
    )

    static let albums: [Album] = [album_starboy, album_after_hours, album_dawn_fm]
    static let tracks: [Track] = album_starboyTracks + album_after_hoursTracks + album_dawn_fmTracks
}
