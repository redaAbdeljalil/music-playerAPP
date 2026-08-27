import Foundation

/// Real catalog data for Teddy Swims.
/// Add another artist by creating a file like this one, then registering it in MusicCatalog.swift.
enum TeddySwimsCatalog {

    static let artist = Artist(
        id: "artist_teddy_swims",
        slug: "teddy_swims",
        name: "Teddy Swims",
        bio: "Georgia-raised vocalist whose soul-soaked runs turned “Lose Control” into a global No. 1.",
        genreLabel: "Soul · Pop",
        originLabel: "Georgia, USA",
        imageAssetName: "artist_teddy_swims",
        accentColorHex: "3A5A78"
    )

    private static let album_i_ve_tried_everything_but_therapy_part_1 = Album(
        id: "album_teddy_swims_i_ve_tried_everything_but_therapy_part_1",
        title: "I've Tried Everything But Therapy (Part 1)",
        artistID: artist.id,
        artistName: artist.name,
        year: 2023,
        genre: .soul,
        artworkAssetName: "album_teddy_swims_i_ve_tried_everything_but_therapy_part_1"
    )

    private static let album_i_ve_tried_everything_but_therapy_part_1Tracks: [Track] = MusicCatalog.makeTracks(
        album: album_i_ve_tried_everything_but_therapy_part_1,
        artist: artist,
        entries: [
            ("Some Things I'll Never Know", 204),
            ("Lose Control", 203),
            ("What More Can I Say", 187),
            ("The Door", 204),
            ("Goodbye's Been Good to You", 191),
            ("Last Communion", 211),
            ("You Still Get to Me", 185),
            ("Suitcase", 172),
            ("Flame", 182),
            ("Evergreen", 176),
        ]
    )

    private static let album_i_ve_tried_everything_but_therapy_part_2 = Album(
        id: "album_teddy_swims_i_ve_tried_everything_but_therapy_part_2",
        title: "I've Tried Everything But Therapy (Part 2)",
        artistID: artist.id,
        artistName: artist.name,
        year: 2025,
        genre: .soul,
        artworkAssetName: "album_teddy_swims_i_ve_tried_everything_but_therapy_part_2"
    )

    private static let album_i_ve_tried_everything_but_therapy_part_2Tracks: [Track] = MusicCatalog.makeTracks(
        album: album_i_ve_tried_everything_but_therapy_part_2,
        artist: artist,
        entries: [
            ("Not Your Man", 185),
            ("Funeral", 198),
            ("Your Kind of Crazy", 182),
            ("Bad Dreams", 184),
            ("Are You Even Real", 201),
            ("Black & White", 178),
            ("Guilty", 176),
        ]
    )

    private static let album_i_ve_tried_everything_but_therapy_complete_edition = Album(
        id: "album_teddy_swims_i_ve_tried_everything_but_therapy_complete_edition",
        title: "I've Tried Everything But Therapy (Complete Edition)",
        artistID: artist.id,
        artistName: artist.name,
        year: 2025,
        genre: .soul,
        artworkAssetName: "album_teddy_swims_i_ve_tried_everything_but_therapy_complete_edition"
    )

    private static let album_i_ve_tried_everything_but_therapy_complete_editionTracks: [Track] = MusicCatalog.makeTracks(
        album: album_i_ve_tried_everything_but_therapy_complete_edition,
        artist: artist,
        entries: [
            ("Need You More", 192),
            ("God Went Crazy", 185),
            ("Free Drugs", 169),
            ("Small Hands", 187),
            ("Dancing With Your Ghost", 200),
            ("All Gas No Brakes", 181),
        ]
    )

    static let albums: [Album] = [album_i_ve_tried_everything_but_therapy_part_1, album_i_ve_tried_everything_but_therapy_part_2, album_i_ve_tried_everything_but_therapy_complete_edition]
    static let tracks: [Track] = album_i_ve_tried_everything_but_therapy_part_1Tracks + album_i_ve_tried_everything_but_therapy_part_2Tracks + album_i_ve_tried_everything_but_therapy_complete_editionTracks
}
