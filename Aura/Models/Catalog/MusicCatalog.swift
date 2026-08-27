import Foundation

/// Single source of truth for the AURA catalog.
///
/// To add another artist: create `CatalogSeed+<Name>.swift` following the shape of the
/// existing files (one `Artist`, a few `Album`s, and `makeTracks` calls for their track
/// lists), then register it in `artists`/`albums`/`tracks` below. Nothing else needs to change —
/// Home, Search, Library, Artist/Album pages, and playback all read from this file alone.
enum MusicCatalog {

    static let artists: [Artist] = [
        SoolkingCatalog.artist,
        TheWeekndCatalog.artist,
        DrakeCatalog.artist,
        TaylorSwiftCatalog.artist,
        TeddySwimsCatalog.artist,
    ]

    static let albums: [Album] =
        SoolkingCatalog.albums +
        TheWeekndCatalog.albums +
        DrakeCatalog.albums +
        TaylorSwiftCatalog.albums +
        TeddySwimsCatalog.albums

    static let tracks: [Track] = applyMoods(to:
        SoolkingCatalog.tracks +
        TheWeekndCatalog.tracks +
        DrakeCatalog.tracks +
        TaylorSwiftCatalog.tracks +
        TeddySwimsCatalog.tracks
    )

    // MARK: - Track construction

    /// Builds a full album's tracks from compact (title, duration) pairs, deriving every other
    /// field — id, artist/album links, artwork, and audio resource name — from the owning
    /// Album/Artist so there's nowhere for those to drift out of sync by hand.
    static func makeTracks(album: Album, artist: Artist, entries: [(String, TimeInterval)]) -> [Track] {
        entries.enumerated().map { index, entry in
            let (title, duration) = entry
            let number = index + 1
            return Track(
                id: "\(album.id)_t\(number)",
                title: title,
                artistID: artist.id,
                artistName: artist.name,
                albumID: album.id,
                albumTitle: album.title,
                trackNumber: number,
                duration: duration,
                artworkAssetName: album.artworkAssetName,
                audioFileName: "\(artist.slug)_\(slug(title))",
                moodIDs: [],
                genre: album.genre
            )
        }
    }

    private static func slug(_ text: String) -> String {
        let folded = text.folding(options: .diacriticInsensitive, locale: .current).lowercased()
        var result = ""
        var lastWasSeparator = false
        for scalar in folded.unicodeScalars {
            if CharacterSet.alphanumerics.contains(scalar) {
                result.unicodeScalars.append(scalar)
                lastWasSeparator = false
            } else if !lastWasSeparator {
                result.append("_")
                lastWasSeparator = true
            }
        }
        return result.trimmingCharacters(in: CharacterSet(charactersIn: "_"))
    }

    // MARK: - Mood curation

    /// Applies curated mood tags to the tracks that carry them, by real track ID. Most tracks
    /// carry no mood — Discover only needs a handful of good fits per mood, not universal coverage.
    private static func applyMoods(to tracks: [Track]) -> [Track] {
        var moodsByTrackID: [String: [String]] = [:]
        for (moodID, trackIDs) in moodTrackIDs {
            for trackID in trackIDs {
                moodsByTrackID[trackID, default: []].append(moodID)
            }
        }
        guard !moodsByTrackID.isEmpty else { return tracks }
        return tracks.map { track in
            guard let assigned = moodsByTrackID[track.id] else { return track }
            return Track(
                id: track.id,
                title: track.title,
                artistID: track.artistID,
                artistName: track.artistName,
                albumID: track.albumID,
                albumTitle: track.albumTitle,
                trackNumber: track.trackNumber,
                duration: track.duration,
                artworkAssetName: track.artworkAssetName,
                audioFileName: track.audioFileName,
                moodIDs: assigned,
                genre: track.genre
            )
        }
    }

    /// Track-to-mood curation, applied centrally so per-artist files stay free of cross-cutting concerns.
    private static let moodTrackIDs: [String: [String]] = [
        "mood_late_night": ["album_soolking_fruit_du_demon_t9", "album_the_weeknd_after_hours_t13", "album_drake_take_care_t6", "album_the_weeknd_after_hours_t11", "album_teddy_swims_i_ve_tried_everything_but_therapy_part_2_t2"],
        "mood_focus": ["album_the_weeknd_after_hours_t5", "album_taylor_swift_folklore_t11", "album_teddy_swims_i_ve_tried_everything_but_therapy_part_1_t10", "album_taylor_swift_folklore_t7"],
        "mood_drive": ["album_soolking_fruit_du_demon_t7", "album_drake_scorpion_t2", "album_the_weeknd_starboy_t1", "album_taylor_swift_1989_t3", "album_soolking_sans_visa_t1"],
        "mood_melancholy": ["album_the_weeknd_after_hours_t11", "album_taylor_swift_folklore_t5", "album_teddy_swims_i_ve_tried_everything_but_therapy_part_1_t5", "album_drake_take_care_t6", "album_teddy_swims_i_ve_tried_everything_but_therapy_part_1_t1"],
        "mood_energy": ["album_soolking_fruit_du_demon_t4", "album_drake_scorpion_t2", "album_the_weeknd_after_hours_t9", "album_taylor_swift_1989_t6", "album_drake_scorpion_t8"],
        "mood_calm": ["album_taylor_swift_folklore_t1", "album_teddy_swims_i_ve_tried_everything_but_therapy_part_1_t10", "album_the_weeknd_after_hours_t5", "album_taylor_swift_folklore_t7"],
        "mood_after_hours": ["album_the_weeknd_after_hours_t13", "album_the_weeknd_dawn_fm_t1", "album_drake_take_care_t6", "album_soolking_fruit_du_demon_t9", "album_the_weeknd_dawn_fm_t13"],
        "mood_sunset": ["album_taylor_swift_1989_t9", "album_soolking_sans_visa_t5", "album_teddy_swims_i_ve_tried_everything_but_therapy_part_1_t9", "album_the_weeknd_starboy_t1"],
        "mood_deep_work": ["album_taylor_swift_folklore_t11", "album_the_weeknd_after_hours_t5", "album_taylor_swift_folklore_t3", "album_teddy_swims_i_ve_tried_everything_but_therapy_part_1_t6"],
    ]

    // MARK: - Moods

    static let moods: [Mood] = [
        Mood(id: "mood_late_night", name: "Late Night", descriptor: "For when the city's gone quiet.", artworkSeed: "mood_late_night", imageAssetName: nil),
        Mood(id: "mood_focus", name: "Focus", descriptor: "Minimal noise, maximum flow.", artworkSeed: "mood_focus", imageAssetName: nil),
        Mood(id: "mood_drive", name: "Drive", descriptor: "Windows down, foot on the gas.", artworkSeed: "mood_drive", imageAssetName: nil),
        Mood(id: "mood_melancholy", name: "Melancholy", descriptor: "Sit with it for a while.", artworkSeed: "mood_melancholy", imageAssetName: nil),
        Mood(id: "mood_energy", name: "Energy", descriptor: "Get the blood moving.", artworkSeed: "mood_energy", imageAssetName: nil),
        Mood(id: "mood_calm", name: "Calm", descriptor: "Slow your breathing down.", artworkSeed: "mood_calm", imageAssetName: nil),
        Mood(id: "mood_after_hours", name: "After Hours", descriptor: "Neon, shadows, and no curfew.", artworkSeed: "mood_after_hours", imageAssetName: nil),
        Mood(id: "mood_sunset", name: "Sunset", descriptor: "Gold light, long shadows.", artworkSeed: "mood_sunset", imageAssetName: nil),
        Mood(id: "mood_deep_work", name: "Deep Work", descriptor: "Heads-down and locked in.", artworkSeed: "mood_deep_work", imageAssetName: nil),
    ]

    // MARK: - Playlists

    static let playlists: [Playlist] = [
        Playlist(
            id: "playlist_this_week",
            title: "This Week",
            subtitle: "Editorial picks across the catalog",
            trackIDs: [
                "album_soolking_fruit_du_demon_t9",
                "album_the_weeknd_after_hours_t9",
                "album_drake_scorpion_t2",
                "album_taylor_swift_midnights_t3",
                "album_teddy_swims_i_ve_tried_everything_but_therapy_part_1_t2",
                "album_soolking_vintage_t1",
                "album_the_weeknd_starboy_t1",
                "album_drake_scorpion_t8"
            ],
            artworkSeed: "playlist_this_week",
            imageAssetName: nil
        ),
        Playlist(
            id: "playlist_night_drive",
            title: "Night Drive Radio",
            subtitle: "Windows down, city lights blurring",
            trackIDs: [
                "album_soolking_fruit_du_demon_t7",
                "album_the_weeknd_after_hours_t13",
                "album_drake_scorpion_t2",
                "album_taylor_swift_1989_t3",
                "album_soolking_sans_visa_t1",
                "album_the_weeknd_starboy_t1"
            ],
            artworkSeed: "playlist_night_drive",
            imageAssetName: nil
        ),
        Playlist(
            id: "playlist_slow_mornings",
            title: "Slow Mornings",
            subtitle: "Coffee, quiet, and no rush",
            trackIDs: [
                "album_taylor_swift_folklore_t1",
                "album_teddy_swims_i_ve_tried_everything_but_therapy_part_1_t10",
                "album_the_weeknd_after_hours_t5",
                "album_taylor_swift_folklore_t7"
            ],
            artworkSeed: "playlist_slow_mornings",
            imageAssetName: nil
        ),
        Playlist(
            id: "playlist_deep_focus",
            title: "Deep Focus Session",
            subtitle: "Heads-down, minimal distraction",
            trackIDs: [
                "album_taylor_swift_folklore_t11",
                "album_the_weeknd_after_hours_t5",
                "album_taylor_swift_folklore_t3",
                "album_teddy_swims_i_ve_tried_everything_but_therapy_part_1_t6"
            ],
            artworkSeed: "playlist_deep_focus",
            imageAssetName: nil
        ),
    ]
}
