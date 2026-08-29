# Aura

Aura is a native iOS music player built with SwiftUI. It's a from-scratch, offline catalog experience Home, Discover, Search, and Library tabs, a full Now Playing screen with queue management, and a design system built around a dark, editorial aesthetic.

## Features

- **Home** — editorial rotation, recently played, and quick access to your library
- **Discover** — mood-based browsing (Late Night, Focus, Drive, Melancholy, Energy, Calm, After Hours, Sunset, Deep Work)
- **Search** — search across tracks, artists, albums, and playlists
- **Library** — liked tracks and saved albums, with play history
- **Now Playing** — expandable full-screen player with a persistent mini-player, queue sheet, and shared-element transitions
- **Artist & Album detail** — full discography browsing per artist

## Catalog

The app ships with a real, hand-seeded catalog rather than placeholder data — artist bios, album art, and tracks for:

- The Weeknd
- Drake
- Taylor Swift
- Teddy Swims
- Soolking

Catalog data lives in `Aura/Models/Catalog/` (`MusicCatalog.swift` + one `CatalogSeed+<Artist>.swift` file per artist), and resource assets (artist photos, album art, audio previews) live under `Aura/Resources/`.

## Architecture

- **UI**: SwiftUI, dark-mode only, custom design system (`Aura/Core/DesignSystem`) covering color, typography, spacing/layout, motion, and iconography
- **Playback**: `PlaybackManager` + `AudioPlayerService` (`Aura/Services/Audio`) drive queueing, playback state, and now-playing updates
- **Data**: `MusicLibraryProviding` protocol backed by `CatalogMusicLibraryService`, which reads from `MusicCatalog` (`Aura/Services/Data`, `Aura/Models/Catalog`)
- **Persistence**: `UserLibraryStore` tracks liked tracks, saved albums, and play history
- **State**: Feature-scoped `ViewModel`s (`HomeViewModel`, `DiscoverViewModel`, `SearchViewModel`, `LibraryViewModel`) feeding SwiftUI views under `Aura/Features/`

```
Aura/
├── App/                 # App entry point
├── Core/
│   ├── DesignSystem/     # Color, typography, layout, motion, icons
│   ├── Components/       # Reusable views (ArtworkView, TrackRow, MiniPlayer, ...)
│   ├── Extensions/
│   └── Utilities/
├── Models/
│   ├── MusicModels.swift # Artist, Album, Track, Playlist, Mood, Genre
│   └── Catalog/          # MusicCatalog + per-artist seed data
├── Services/
│   ├── Audio/            # Playback engine
│   └── Data/             # Library service, user library store
└── Features/
    ├── Home/
    ├── Discover/
    ├── Search/
    ├── Library/
    ├── ArtistDetail/
    ├── AlbumDetail/
    ├── NowPlaying/
    └── Root/              # Tab bar + root navigation
```

## Requirements

- Xcode 26.6 or later
- iOS 26.5+
- Swift 5.0

## Getting Started

1. Clone the repository
   ```bash
   git clone https://github.com/redaAbdeljalil/music-playerAPP.git
   ```
2. Open `Aura.xcodeproj` in Xcode
3. Select an iOS Simulator (or a connected device)
4. Build and run (`⌘R`)

No external dependencies or API keys are required the app runs entirely on the bundled catalog and sample audio.

## Tech Stack

- SwiftUI
- Swift Concurrency
- AVFoundation (audio playback)
- No third-party packages

## License

All rights reserved. This project is not currently licensed for reuse contact the author for permission.
