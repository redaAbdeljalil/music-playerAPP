# Album covers

Drop a cover in here named exactly `album_<artist_slug>_<album_slug>.jpg` (or `.jpeg` / `.png` /
`.heic`) and it replaces the generated placeholder automatically — no code changes needed.

Covers are flat in one folder (not nested per-artist) so the app can look a file up by name
directly without having to guess a subfolder — see `../MEDIA_CHECKLIST.md` for the exact filename
expected for every album, or check `artworkAssetName` on any `Album` in
`Aura/Models/Catalog/CatalogSeed+<Artist>.swift`.

Every track on an album shares that album's cover automatically (via `Track.artworkAssetName`,
copied from its `Album` when the catalog is built) — you only ever need one image per album, not
one per track.
