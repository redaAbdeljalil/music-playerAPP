import Foundation

/// Real catalog data for Drake.
/// Add another artist by creating a file like this one, then registering it in MusicCatalog.swift.
enum DrakeCatalog {

    static let artist = Artist(
        id: "artist_drake",
        slug: "drake",
        name: "Drake",
        bio: "Toronto's biggest musical export — genre-blurring rap and R&B that's topped the charts since Take Care.",
        genreLabel: "Hip-Hop · Rap",
        originLabel: "Toronto, Canada",
        imageAssetName: "artist_drake",
        accentColorHex: "2F5D50"
    )

    private static let album_take_care = Album(
        id: "album_drake_take_care",
        title: "Take Care",
        artistID: artist.id,
        artistName: artist.name,
        year: 2011,
        genre: .hipHop,
        artworkAssetName: "album_drake_take_care"
    )

    private static let album_take_careTracks: [Track] = MusicCatalog.makeTracks(
        album: album_take_care,
        artist: artist,
        entries: [
            ("Over My Dead Body", 251),
            ("Shot for Me", 235),
            ("Headlines", 233),
            ("Crew Love", 296),
            ("Take Care", 279),
            ("Marvins Room", 293),
            ("Under Ground Kings", 236),
            ("We'll Be Fine", 247),
            ("Make Me Proud", 219),
            ("Lord Knows", 335),
            ("Doing It Wrong", 256),
            ("The Real Her", 332),
            ("Look What You've Done", 316),
            ("HYFR", 264),
            ("The Ride", 371),
        ]
    )

    private static let album_scorpion = Album(
        id: "album_drake_scorpion",
        title: "Scorpion",
        artistID: artist.id,
        artistName: artist.name,
        year: 2018,
        genre: .hipHop,
        artworkAssetName: "album_drake_scorpion"
    )

    private static let album_scorpionTracks: [Track] = MusicCatalog.makeTracks(
        album: album_scorpion,
        artist: artist,
        entries: [
            ("Survival", 201),
            ("Nonstop", 254),
            ("God's Plan", 199),
            ("Emotionless", 303),
            ("Mob Ties", 200),
            ("Sandra's Rose", 263),
            ("Talk Up", 260),
            ("Nice for What", 211),
            ("In My Feelings", 217),
            ("Don't Matter to Me", 320),
            ("March 14", 322),
            ("Finesse", 161),
            ("I'm Upset", 203),
            ("Elevate", 176),
        ]
    )

    private static let album_certified_lover_boy = Album(
        id: "album_drake_certified_lover_boy",
        title: "Certified Lover Boy",
        artistID: artist.id,
        artistName: artist.name,
        year: 2021,
        genre: .hipHop,
        artworkAssetName: "album_drake_certified_lover_boy"
    )

    private static let album_certified_lover_boyTracks: [Track] = MusicCatalog.makeTracks(
        album: album_certified_lover_boy,
        artist: artist,
        entries: [
            ("Champagne Poetry", 371),
            ("Papi's Home", 181),
            ("Girls Want Girls", 195),
            ("In the Bible", 303),
            ("Love All", 259),
            ("Fair Trade", 243),
            ("Way 2 Sexy", 256),
            ("TSU", 187),
            ("N 2 Deep", 269),
            ("Pipe Down", 155),
            ("No Friends in the Industry", 219),
            ("Knife Talk", 314),
            ("7am on Bridle Path", 383),
        ]
    )

    static let albums: [Album] = [album_take_care, album_scorpion, album_certified_lover_boy]
    static let tracks: [Track] = album_take_careTracks + album_scorpionTracks + album_certified_lover_boyTracks
}
