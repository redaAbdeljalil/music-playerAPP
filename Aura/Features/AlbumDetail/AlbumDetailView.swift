import SwiftUI

struct AlbumDetailView: View {
    let album: Album

    @EnvironmentObject private var playback: PlaybackManager
    private let library: MusicLibraryProviding = CatalogMusicLibraryService()

    private var tracks: [Track] {
        library.tracks(forAlbum: album.id)
    }

    private var artist: Artist? {
        library.artist(byID: album.artistID)
    }

    private var otherAlbumsByArtist: [Album] {
        guard let artist else { return [] }
        return library.albums(forArtist: artist.id).filter { $0.id != album.id }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AURASpacing.lg) {
                header
                actions
                trackList

                if !otherAlbumsByArtist.isEmpty, let artist {
                    moreByArtistSection(artist)
                }
            }
            .padding(.bottom, AURASpacing.xxxl)
        }
        .background(AURAColor.ink.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(AURAColor.ink, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: AURASpacing.sm) {
            ArtworkView(
                assetName: album.artworkAssetName,
                seed: album.id,
                tintHex: artist?.accentColorHex,
                cornerRadius: AURARadius.lg
            )
            .frame(width: 220, height: 220)
            .auraShadow(AURAShadow.elevated)

            VStack(spacing: 3) {
                Text(album.title)
                    .font(AURAType.display)
                    .foregroundStyle(AURAColor.bone)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)

                if let artist {
                    NavigationLink(value: artist) {
                        Text(album.artistName)
                            .font(AURAType.body)
                            .foregroundStyle(AURAColor.ember)
                    }
                    .buttonStyle(.plain)
                } else {
                    Text(album.artistName)
                        .font(AURAType.body)
                        .foregroundStyle(AURAColor.ash)
                }

                Text("\(album.year) · \(album.genre.displayName) · \(tracks.count) tracks")
                    .font(AURAType.caption)
                    .foregroundStyle(AURAColor.ash)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, AURASpacing.lg)
        .padding(.horizontal, AURASpacing.md)
    }

    private var actions: some View {
        HStack(spacing: AURASpacing.sm) {
            Button {
                guard let first = tracks.first else { return }
                playback.play(track: first, in: tracks)
            } label: {
                Label("Play", systemImage: AURAIcon.play)
            }
            .buttonStyle(.auraPrimary)
            .disabled(tracks.isEmpty)

            Button {
                guard let first = tracks.first else { return }
                if !playback.shuffleEnabled {
                    playback.toggleShuffle()
                }
                playback.play(track: first, in: tracks)
                HapticsManager.selection()
            } label: {
                Image(systemName: AURAIcon.shuffle)
                    .foregroundStyle(AURAColor.bone)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(AURAColor.inkElevated))
            }
            .buttonStyle(.plain)
            .disabled(tracks.isEmpty)
            .accessibilityLabel("Shuffle \(album.title)")
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, AURASpacing.md)
    }

    // MARK: - Track list

    private var trackList: some View {
        LazyVStack(spacing: AURASpacing.xs) {
            ForEach(tracks) { track in
                TrackRow(track: track, isActive: playback.isCurrentTrack(track), rank: track.trackNumber) {
                    playback.play(track: track, in: tracks)
                }
            }
        }
        .padding(.horizontal, AURASpacing.md)
    }

    // MARK: - More by artist

    private func moreByArtistSection(_ artist: Artist) -> some View {
        VStack(alignment: .leading, spacing: AURASpacing.sm) {
            SectionHeader(title: "More by \(artist.name)")
                .padding(.horizontal, AURASpacing.md)
            AlbumShelf(albums: otherAlbumsByArtist)
        }
    }
}
