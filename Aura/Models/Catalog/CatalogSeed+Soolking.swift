import Foundation

/// Real catalog data for Soolking.
/// Add another artist by creating a file like this one, then registering it in MusicCatalog.swift.
enum SoolkingCatalog {

    static let artist = Artist(
        id: "artist_soolking",
        slug: "soolking",
        name: "Soolking",
        bio: "Algerian-French rapper and singer known for fusing trap production with raï melody, and for anthems like “Dalida” and “Liberté.”",
        genreLabel: "Rap · Raï",
        originLabel: "Algeria",
        imageAssetName: "artist_soolking",
        accentColorHex: "C98A3E"
    )

    private static let album_fruit_du_demon = Album(
        id: "album_soolking_fruit_du_demon",
        title: "Fruit du Démon",
        artistID: artist.id,
        artistName: artist.name,
        year: 2018,
        genre: .rap,
        artworkAssetName: "album_soolking_fruit_du_demon"
    )

    private static let album_fruit_du_demonTracks: [Track] = MusicCatalog.makeTracks(
        album: album_fruit_du_demon,
        artist: artist,
        entries: [
            ("Rockstar", 168),
            ("Bambina", 185),
            ("Amsterdam", 183),
            ("Guérilla", 229),
            ("Gucci", 174),
            ("Tata", 192),
            ("Vroom Vroom", 178),
            ("HLM", 200),
            ("Dalida", 211),
            ("Chica", 187),
            ("Cosa Nostra", 264),
            ("Youv", 182),
            ("Mirage", 195),
            ("Paradise", 205),
        ]
    )

    private static let album_vintage = Album(
        id: "album_soolking_vintage",
        title: "Vintage",
        artistID: artist.id,
        artistName: artist.name,
        year: 2020,
        genre: .rap,
        artworkAssetName: "album_soolking_vintage"
    )

    private static let album_vintageTracks: [Track] = MusicCatalog.makeTracks(
        album: album_vintage,
        artist: artist,
        entries: [
            ("Ça fait des années", 208),
            ("Maryline", 191),
            ("Hayati", 149),
            ("La Kichta", 185),
            ("Chihuahua", 172),
            ("CNLZ", 198),
            ("On Ira", 180),
            ("Meleğim", 221),
            ("Billie Holiday", 189),
            ("Business", 175),
            ("Corbeau", 194),
            ("Dangereuse", 167),
            ("Douleur", 202),
            ("Folie", 178),
        ]
    )

    private static let album_sans_visa = Album(
        id: "album_soolking_sans_visa",
        title: "Sans Visa",
        artistID: artist.id,
        artistName: artist.name,
        year: 2022,
        genre: .rap,
        artworkAssetName: "album_soolking_sans_visa"
    )

    private static let album_sans_visaTracks: [Track] = MusicCatalog.makeTracks(
        album: album_sans_visa,
        artist: artist,
        entries: [
            ("Kurt Cobain", 159),
            ("Balader", 176),
            ("Suavemente", 159),
            ("Sel3a", 169),
            ("Fiesta", 148),
            ("Reste", 183),
            ("Parano", 158),
            ("Askim", 173),
            ("Maria", 199),
            ("Baila", 145),
            ("Sans Visa", 206),
            ("Bye Bye", 176),
            ("Lela", 169),
            ("Fada", 166),
        ]
    )

    static let albums: [Album] = [album_fruit_du_demon, album_vintage, album_sans_visa]
    static let tracks: [Track] = album_fruit_du_demonTracks + album_vintageTracks + album_sans_visaTracks
}
