# Track audio

Drop a file in here named exactly `<audioFileName>.mp3` (or `.m4a` / `.wav` / `.aac`) and it
replaces the placeholder automatically — no code changes needed. See `../MEDIA_CHECKLIST.md` for
the exact filename expected for every track, or check `audioFileName` on any `Track` in
`Aura/Models/Catalog/CatalogSeed+<Artist>.swift`.

Until a track's real file is added, `AudioPlayerService` automatically falls back to one of the
6 bundled sample clips in `Resources/SampleAudio/`, chosen deterministically per track — so every
row in the app is genuinely playable today, and swapping in the real file later is the only thing
that needs to change.

Do not delete `Resources/SampleAudio/` — it's what makes playback work before real audio is added.
