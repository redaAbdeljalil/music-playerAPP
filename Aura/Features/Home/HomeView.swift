import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject private var playback: PlaybackManager
    @EnvironmentObject private var libraryStore: UserLibraryStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AURASpacing.xl) {
                    header

                    if let current = playback.currentTrack {
                        continueListening(current)
                    }

                    if let featured = viewModel.featured {
                        spotlightSection(featured)
                    }

                    if !viewModel.rotation.isEmpty {
                        rotationSection
                    }

                    artistsSection

                    if !viewModel.exploreAlbums.isEmpty {
                        albumsSection
                    }

                    moodSection

                    if !libraryStore.recentlyPlayed.isEmpty {
                        recentlyPlayedSection
                    }
                }
                .padding(.top, AURASpacing.sm)
                .padding(.bottom, AURASpacing.xxxl)
            }
            .background(AURAColor.ink.ignoresSafeArea())
            .navigationDestination(for: Artist.self) { artist in
                ArtistDetailView(artist: artist)
            }
            .navigationDestination(for: Album.self) { album in
                AlbumDetailView(album: album)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    // MARK: - Sections

    private var header: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(viewModel.greeting)
                .font(AURAType.hero)
                .foregroundStyle(AURAColor.bone)
            Text("Let the room set the tone.")
                .font(AURAType.body)
                .foregroundStyle(AURAColor.ash)
        }
        .padding(.horizontal, AURASpacing.md)
        .accessibilityElement(children: .combine)
    }

    private func continueListening(_ current: Track) -> some View {
        Button {
            playback.togglePlayPause()
            HapticsManager.tap()
        } label: {
            HStack(spacing: AURASpacing.sm) {
                ArtworkView(assetName: current.artworkAssetName, seed: current.albumID, cornerRadius: AURARadius.sm)
                    .frame(width: 56, height: 56)

                VStack(alignment: .leading, spacing: 2) {
                    Text("CONTINUE LISTENING")
                        .font(AURAType.label)
                        .foregroundStyle(AURAColor.ember)
                    Text(current.title)
                        .font(AURAType.body)
                        .foregroundStyle(AURAColor.bone)
                        .lineLimit(1)
                    Text(current.artistName)
                        .font(AURAType.caption)
                        .foregroundStyle(AURAColor.ash)
                        .lineLimit(1)
                }

                Spacer()

                Image(systemName: playback.isPlaying ? AURAIcon.pause : AURAIcon.play)
                    .foregroundStyle(AURAColor.bone)
            }
            .padding(AURASpacing.sm)
            .background(RoundedRectangle(cornerRadius: AURARadius.md, style: .continuous).fill(AURAColor.inkElevated))
            .padding(.horizontal, AURASpacing.md)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Continue listening: \(current.title) by \(current.artistName)")
    }

    /// The editorial replacement for a generic "featured card": artwork sits inset beside an
    /// oversized artist name rather than behind a full-bleed gradient, so the type — not a stock
    /// card shape — carries the moment.
    private func spotlightSection(_ track: Track) -> some View {
        VStack(alignment: .leading, spacing: AURASpacing.md) {
            Text("TODAY'S SPOTLIGHT")
                .font(AURAType.label)
                .foregroundStyle(AURAColor.ash)
                .padding(.horizontal, AURASpacing.md)

            HStack(alignment: .top, spacing: AURASpacing.md) {
                Button {
                    playback.play(track: track, in: [track] + viewModel.rotation)
                } label: {
                    ArtworkView(
                        assetName: track.artworkAssetName,
                        seed: track.albumID,
                        tintHex: viewModel.accentHex(forArtistID: track.artistID),
                        cornerRadius: AURARadius.lg
                    )
                    .frame(width: 128, height: 128)
                    .auraShadow(AURAShadow.soft)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Play \(track.title) by \(track.artistName)")

                VStack(alignment: .leading, spacing: AURASpacing.xxs) {
                    Text(track.artistName)
                        .font(AURAType.colossal)
                        .foregroundStyle(AURAColor.bone)
                        .lineLimit(2)
                        .minimumScaleFactor(0.55)
                    Text(track.title)
                        .font(AURAType.body)
                        .foregroundStyle(AURAColor.ash)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, AURASpacing.xxs)
            }
            .padding(.horizontal, AURASpacing.md)

            Button {
                playback.play(track: track, in: [track] + viewModel.rotation)
            } label: {
                Label("Play", systemImage: AURAIcon.play)
            }
            .buttonStyle(.auraPrimary)
            .padding(.horizontal, AURASpacing.md)
        }
    }

    private var rotationSection: some View {
        VStack(alignment: .leading, spacing: AURASpacing.sm) {
            SectionHeader(title: "This week's rotation")
                .padding(.horizontal, AURASpacing.md)
            LazyVStack(spacing: AURASpacing.xs) {
                ForEach(Array(viewModel.rotation.enumerated()), id: \.element.id) { index, track in
                    TrackRow(track: track, isActive: playback.isCurrentTrack(track), rank: index + 1) {
                        playback.play(track: track, in: viewModel.rotation)
                    }
                }
            }
            .padding(.horizontal, AURASpacing.md)
        }
    }

    private var artistsSection: some View {
        VStack(alignment: .leading, spacing: AURASpacing.sm) {
            SectionHeader(title: "Artists")
                .padding(.horizontal, AURASpacing.md)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AURASpacing.lg) {
                    ForEach(viewModel.recommendedArtists) { artist in
                        NavigationLink(value: artist) {
                            VStack(spacing: AURASpacing.xxs) {
                                ArtworkView(
                                    assetName: artist.imageAssetName,
                                    seed: artist.id,
                                    tintHex: artist.accentColorHex,
                                    cornerRadius: AURARadius.lg
                                )
                                .frame(width: 96, height: 96)
                                Text(artist.name)
                                    .font(AURAType.caption)
                                    .foregroundStyle(AURAColor.bone)
                                    .lineLimit(1)
                                    .frame(width: 96)
                            }
                            .accessibilityElement(children: .combine)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, AURASpacing.md)
            }
        }
    }

    private var albumsSection: some View {
        VStack(alignment: .leading, spacing: AURASpacing.sm) {
            SectionHeader(title: "Albums to explore")
                .padding(.horizontal, AURASpacing.md)
            AlbumShelf(albums: viewModel.exploreAlbums)
        }
    }

    private var moodSection: some View {
        VStack(alignment: .leading, spacing: AURASpacing.sm) {
            SectionHeader(title: "Set the mood")
                .padding(.horizontal, AURASpacing.md)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AURASpacing.md) {
                    ForEach(viewModel.moods) { mood in
                        MoodTile(mood: mood, height: 140)
                            .frame(width: 200)
                    }
                }
                .padding(.horizontal, AURASpacing.md)
            }
        }
    }

    private var recentlyPlayedSection: some View {
        VStack(alignment: .leading, spacing: AURASpacing.sm) {
            SectionHeader(title: "Recently played")
                .padding(.horizontal, AURASpacing.md)
            TrackShelf(tracks: libraryStore.recentlyPlayed) { track in
                playback.play(track: track, in: libraryStore.recentlyPlayed)
            }
        }
    }
}
