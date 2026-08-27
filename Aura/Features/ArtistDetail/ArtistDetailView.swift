import SwiftUI

struct ArtistDetailView: View {
    let artist: Artist

    @EnvironmentObject private var playback: PlaybackManager
    private let library: MusicLibraryProviding = CatalogMusicLibraryService()

    private var allArtistTracks: [Track] {
        library.tracks(forArtist: artist.id)
    }

    private var popularTracks: [Track] {
        Array(allArtistTracks.prefix(5))
    }

    private var albums: [Album] {
        library.albums(forArtist: artist.id).sorted { $0.year > $1.year }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AURASpacing.xl) {
                header
                actions

                if !popularTracks.isEmpty {
                    popularSection
                }

                if !albums.isEmpty {
                    albumsSection
                }

                bioSection
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
        ZStack(alignment: .bottomLeading) {
            ArtworkView(
                assetName: artist.imageAssetName,
                seed: artist.id,
                tintHex: artist.accentColorHex,
                cornerRadius: 0
            )
            .frame(height: 340)
            .clipped()

            LinearGradient(colors: [.clear, AURAColor.ink], startPoint: .center, endPoint: .bottom)
                .frame(height: 340)

            VStack(alignment: .leading, spacing: 4) {
                Text("\(artist.genreLabel.uppercased())  ·  \(artist.originLabel.uppercased())")
                    .font(AURAType.label)
                    .foregroundStyle(.white.opacity(0.75))
                Text(artist.name)
                    .font(AURAType.colossal)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.6)
            }
            .padding(AURASpacing.md)
        }
        .accessibilityElement(children: .combine)
    }

    private var actions: some View {
        HStack(spacing: AURASpacing.sm) {
            Button {
                guard let first = allArtistTracks.first else { return }
                playback.play(track: first, in: allArtistTracks)
            } label: {
                Label("Play", systemImage: AURAIcon.play)
            }
            .buttonStyle(.auraPrimary)
            .disabled(allArtistTracks.isEmpty)

            Button {
                guard let first = allArtistTracks.first else { return }
                if !playback.shuffleEnabled {
                    playback.toggleShuffle()
                }
                playback.play(track: first, in: allArtistTracks)
                HapticsManager.selection()
            } label: {
                Image(systemName: AURAIcon.shuffle)
                    .foregroundStyle(AURAColor.bone)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(AURAColor.inkElevated))
            }
            .buttonStyle(.plain)
            .disabled(allArtistTracks.isEmpty)
            .accessibilityLabel("Shuffle \(artist.name)")
        }
        .padding(.horizontal, AURASpacing.md)
    }

    // MARK: - Popular

    private var popularSection: some View {
        VStack(alignment: .leading, spacing: AURASpacing.sm) {
            SectionHeader(title: "Popular")
                .padding(.horizontal, AURASpacing.md)
            LazyVStack(spacing: AURASpacing.xs) {
                ForEach(Array(popularTracks.enumerated()), id: \.element.id) { index, track in
                    TrackRow(track: track, isActive: playback.isCurrentTrack(track), rank: index + 1) {
                        playback.play(track: track, in: allArtistTracks)
                    }
                }
            }
            .padding(.horizontal, AURASpacing.md)
        }
    }

    // MARK: - Albums

    private var albumsSection: some View {
        VStack(alignment: .leading, spacing: AURASpacing.sm) {
            SectionHeader(title: "Albums")
                .padding(.horizontal, AURASpacing.md)
            AlbumShelf(albums: albums)
        }
    }

    // MARK: - Bio

    private var bioSection: some View {
        VStack(alignment: .leading, spacing: AURASpacing.xs) {
            SectionHeader(title: "About")
                .padding(.horizontal, AURASpacing.md)
            Text(artist.bio)
                .font(AURAType.body)
                .foregroundStyle(AURAColor.ash)
                .padding(.horizontal, AURASpacing.md)
        }
    }
}
