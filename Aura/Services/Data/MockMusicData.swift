import Foundation

/// A single, centralized source of mock content. Nothing in the Features
/// layer should hardcode track/artist/mood data directly — everything
/// flows through `MusicLibraryProviding`, which this file backs. Swapping
/// this out for a real API later means writing one new type that conforms
/// to `MusicLibraryProviding`; nothing else in the app needs to change.
///
/// All artist, track, album, and playlist names below are original and
/// fictional — invented for this project, not drawn from any real catalog.
enum MockMusicData {

    // MARK: - Artists

    static let artists: [Artist] = [
        Artist(id: "artist_nadia_vale", name: "Nadia Vale", bio: "Warm, unhurried soul with a torch-song heart."),
        Artist(id: "artist_kilo_static", name: "Kilo Static", bio: "High-voltage electronic production, built for motion."),
        Artist(id: "artist_half_light", name: "Half Light", bio: "Ambient textures for the hours between things."),
        Artist(id: "artist_reverie_sun", name: "Reverie Sun", bio: "Indie songwriting with a wide-open horizon."),
        Artist(id: "artist_marlow_dune", name: "Marlow Dune", bio: "Late-night jazz, brushed drums and low light."),
        Artist(id: "artist_glass_coast", name: "Glass Coast", bio: "Electronic duo chasing the after-hours glow."),
        Artist(id: "artist_nightbloom", name: "Nightbloom", bio: "Experimental sound design, slow-blooming and strange."),
        Artist(id: "artist_orinthia", name: "Orinthia", bio: "Lo-fi loops built for focus and quiet mornings.")
    ]

    // MARK: - Albums

    static let albums: [Album] = [
        Album(id: "album_amber_hours", title: "Amber Hours", artistName: "Nadia Vale", year: 2025, artworkSeed: "album_amber_hours"),
        Album(id: "album_static_bloom", title: "Static Bloom", artistName: "Kilo Static", year: 2024, artworkSeed: "album_static_bloom"),
        Album(id: "album_low_tide", title: "Low Tide", artistName: "Half Light", year: 2026, artworkSeed: "album_low_tide"),
        Album(id: "album_paper_moon", title: "Paper Moon", artistName: "Reverie Sun", year: 2023, artworkSeed: "album_paper_moon"),
        Album(id: "album_salt_and_silence", title: "Salt & Silence", artistName: "Marlow Dune", year: 2025, artworkSeed: "album_salt_and_silence"),
        Album(id: "album_afterglow_district", title: "Afterglow District", artistName: "Glass Coast", year: 2024, artworkSeed: "album_afterglow_district"),
        Album(id: "album_marrow", title: "Marrow", artistName: "Nightbloom", year: 2026, artworkSeed: "album_marrow"),
        Album(id: "album_cassette_sky", title: "Cassette Sky", artistName: "Orinthia", year: 2022, artworkSeed: "album_cassette_sky")
    ]

    // MARK: - Moods

    static let moods: [Mood] = [
        Mood(id: "mood_late_night", name: "Late Night", descriptor: "Neon hush and empty streets.", artworkSeed: "mood_late_night"),
        Mood(id: "mood_focus", name: "Focus", descriptor: "Clear head, steady hands.", artworkSeed: "mood_focus"),
        Mood(id: "mood_drive", name: "Drive", descriptor: "Windows down, horizon out.", artworkSeed: "mood_drive"),
        Mood(id: "mood_melancholy", name: "Melancholy", descriptor: "Beautiful, a little heavy.", artworkSeed: "mood_melancholy"),
        Mood(id: "mood_energy", name: "Energy", descriptor: "Pulse up, volume up.", artworkSeed: "mood_energy"),
        Mood(id: "mood_calm", name: "Calm", descriptor: "Slow exhale, soft light.", artworkSeed: "mood_calm"),
        Mood(id: "mood_after_hours", name: "After Hours", descriptor: "The city, unwound.", artworkSeed: "mood_after_hours"),
        Mood(id: "mood_sunset", name: "Sunset", descriptor: "Gold hour, long shadows.", artworkSeed: "mood_sunset"),
        Mood(id: "mood_deep_work", name: "Deep Work", descriptor: "Heads down, no noise.", artworkSeed: "mood_deep_work")
    ]

    // MARK: - Tracks
    //
    // `audioFileName` cycles through the six bundled placeholder ambient
    // tones in Resources/SampleAudio (see README for details). `duration`
    // matches each file's real length exactly so the UI never shows a
    // mismatched scrubber.

    static let tracks: [Track] = [
        Track(id: "track_amber_hours", title: "Amber Hours", artistName: "Nadia Vale", albumID: "album_amber_hours", albumTitle: "Amber Hours", duration: 24, artworkSeed: "track_amber_hours", audioFileName: "aura_sample_1", moodIDs: ["mood_late_night", "mood_after_hours"], genre: .soul),
        Track(id: "track_slow_static", title: "Slow Static", artistName: "Nadia Vale", albumID: "album_amber_hours", albumTitle: "Amber Hours", duration: 31, artworkSeed: "track_slow_static", audioFileName: "aura_sample_2", moodIDs: ["mood_calm"], genre: .soul),
        Track(id: "track_halfway_gone", title: "Halfway Gone", artistName: "Nadia Vale", albumID: "album_amber_hours", albumTitle: "Amber Hours", duration: 27, artworkSeed: "track_halfway_gone", audioFileName: "aura_sample_3", moodIDs: ["mood_melancholy"], genre: .soul),

        Track(id: "track_static_bloom", title: "Static Bloom", artistName: "Kilo Static", albumID: "album_static_bloom", albumTitle: "Static Bloom", duration: 35, artworkSeed: "track_static_bloom", audioFileName: "aura_sample_4", moodIDs: ["mood_energy", "mood_drive"], genre: .electronic),
        Track(id: "track_wire_and_bone", title: "Wire & Bone", artistName: "Kilo Static", albumID: "album_static_bloom", albumTitle: "Static Bloom", duration: 22, artworkSeed: "track_wire_and_bone", audioFileName: "aura_sample_5", moodIDs: ["mood_energy"], genre: .electronic),

        Track(id: "track_low_tide", title: "Low Tide", artistName: "Half Light", albumID: "album_low_tide", albumTitle: "Low Tide", duration: 29, artworkSeed: "track_low_tide", audioFileName: "aura_sample_6", moodIDs: ["mood_calm", "mood_sunset"], genre: .ambient),
        Track(id: "track_undertow", title: "Undertow", artistName: "Half Light", albumID: "album_low_tide", albumTitle: "Low Tide", duration: 24, artworkSeed: "track_undertow", audioFileName: "aura_sample_1", moodIDs: ["mood_deep_work", "mood_calm"], genre: .ambient),
        Track(id: "track_shoreline", title: "Shoreline", artistName: "Half Light", albumID: "album_low_tide", albumTitle: "Low Tide", duration: 31, artworkSeed: "track_shoreline", audioFileName: "aura_sample_2", moodIDs: ["mood_sunset"], genre: .ambient),

        Track(id: "track_paper_moon_drive", title: "Paper Moon Drive", artistName: "Reverie Sun", albumID: "album_paper_moon", albumTitle: "Paper Moon", duration: 27, artworkSeed: "track_paper_moon_drive", audioFileName: "aura_sample_3", moodIDs: ["mood_drive"], genre: .indie),
        Track(id: "track_marigold", title: "Marigold", artistName: "Reverie Sun", albumID: "album_paper_moon", albumTitle: "Paper Moon", duration: 35, artworkSeed: "track_marigold", audioFileName: "aura_sample_4", moodIDs: ["mood_sunset", "mood_melancholy"], genre: .indie),

        Track(id: "track_salt_and_silence", title: "Salt & Silence", artistName: "Marlow Dune", albumID: "album_salt_and_silence", albumTitle: "Salt & Silence", duration: 22, artworkSeed: "track_salt_and_silence", audioFileName: "aura_sample_5", moodIDs: ["mood_late_night", "mood_melancholy"], genre: .jazz),
        Track(id: "track_smoke_signal", title: "Smoke Signal", artistName: "Marlow Dune", albumID: "album_salt_and_silence", albumTitle: "Salt & Silence", duration: 29, artworkSeed: "track_smoke_signal", audioFileName: "aura_sample_6", moodIDs: ["mood_late_night"], genre: .jazz),

        Track(id: "track_afterglow_district", title: "Afterglow District", artistName: "Glass Coast", albumID: "album_afterglow_district", albumTitle: "Afterglow District", duration: 24, artworkSeed: "track_afterglow_district", audioFileName: "aura_sample_1", moodIDs: ["mood_after_hours", "mood_energy"], genre: .electronic),
        Track(id: "track_neon_static", title: "Neon Static", artistName: "Glass Coast", albumID: "album_afterglow_district", albumTitle: "Afterglow District", duration: 31, artworkSeed: "track_neon_static", audioFileName: "aura_sample_2", moodIDs: ["mood_drive", "mood_energy"], genre: .electronic),

        Track(id: "track_marrow", title: "Marrow", artistName: "Nightbloom", albumID: "album_marrow", albumTitle: "Marrow", duration: 27, artworkSeed: "track_marrow", audioFileName: "aura_sample_3", moodIDs: ["mood_deep_work"], genre: .experimental),
        Track(id: "track_cassette_ghost", title: "Cassette Ghost", artistName: "Nightbloom", albumID: "album_marrow", albumTitle: "Marrow", duration: 35, artworkSeed: "track_cassette_ghost", audioFileName: "aura_sample_4", moodIDs: ["mood_melancholy", "mood_deep_work"], genre: .experimental),

        Track(id: "track_cassette_sky", title: "Cassette Sky", artistName: "Orinthia", albumID: "album_cassette_sky", albumTitle: "Cassette Sky", duration: 22, artworkSeed: "track_cassette_sky", audioFileName: "aura_sample_5", moodIDs: ["mood_focus", "mood_calm"], genre: .lofi),
        Track(id: "track_paper_cranes", title: "Paper Cranes", artistName: "Orinthia", albumID: "album_cassette_sky", albumTitle: "Cassette Sky", duration: 29, artworkSeed: "track_paper_cranes", audioFileName: "aura_sample_6", moodIDs: ["mood_focus"], genre: .lofi)
    ]

    // MARK: - Playlists

    static let playlists: [Playlist] = [
        Playlist(
            id: "playlist_editorial_this_week",
            title: "Editorial: This Week",
            subtitle: "Our current rotation",
            trackIDs: ["track_amber_hours", "track_static_bloom", "track_low_tide", "track_paper_moon_drive", "track_afterglow_district", "track_marrow"],
            artworkSeed: "playlist_editorial_this_week"
        ),
        Playlist(
            id: "playlist_night_drive_radio",
            title: "Night Drive Radio",
            subtitle: "For empty highways",
            trackIDs: ["track_static_bloom", "track_paper_moon_drive", "track_neon_static", "track_wire_and_bone"],
            artworkSeed: "playlist_night_drive_radio"
        ),
        Playlist(
            id: "playlist_slow_mornings",
            title: "Slow Mornings",
            subtitle: "Unhurried, unbothered",
            trackIDs: ["track_low_tide", "track_shoreline", "track_marigold", "track_cassette_sky"],
            artworkSeed: "playlist_slow_mornings"
        ),
        Playlist(
            id: "playlist_deep_focus_session",
            title: "Deep Focus Session",
            subtitle: "Heads-down hours",
            trackIDs: ["track_cassette_sky", "track_paper_cranes", "track_undertow", "track_marrow"],
            artworkSeed: "playlist_deep_focus_session"
        )
    ]
}
