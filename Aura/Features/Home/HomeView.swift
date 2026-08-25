import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject private var playback: PlaybackManager
    @EnvironmentObject private var libraryStore: UserLibraryStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AURASpacing.xl) {
                header

                if let current = playback.currentTrack {
                    continueListening(current)
                }

                if let featured = viewModel.featured {
                    featuredSection(featured)
                }

                curatedSection

                moodSection

                if !libraryStore.recentlyPlayed.isEmpty {
                    recentlyPlayedSection
                }

                artistsSection
            }
            .padding(.top, AURASpacing.sm)
            .padding(.bottom, AURASpacing.xxxl)
        }
        .background(AURAColor.ink.ignoresSafeArea())
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
                ArtworkView(seed: current.artworkSeed, cornerRadius: AURARadius.sm)
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

    private func featuredSection(_ track: Track) -> some View {
        VStack(alignment: .leading, spacing: AURASpacing.sm) {
            Text("TODAY'S FEATURE")
                .font(AURAType.label)
                .foregroundStyle(AURAColor.ash)
                .padding(.horizontal, AURASpacing.md)

            Button {
                playback.play(track: track, in: [track] + viewModel.curated)
            } label: {
                ZStack(alignment: .bottomLeading) {
                    ArtworkView(seed: track.artworkSeed, cornerRadius: AURARadius.lg)
                    LinearGradient(colors: [.clear, .black.opacity(0.65)], startPoint: .center, endPoint: .bottom)
                        .clipShape(RoundedRectangle(cornerRadius: AURARadius.lg, style: .continuous))

                    VStack(alignment: .leading, spacing: AURASpacing.xxs) {
                        Text(track.title)
                            .font(AURAType.display)
                            .foregroundStyle(.white)
                        Text(track.artistName)
                            .font(AURAType.body)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .padding(AURASpacing.md)
                }
                .frame(height: 320)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, AURASpacing.md)
            .accessibilityLabel("Today's feature: \(track.title) by \(track.artistName). Double tap to play.")
        }
    }

    private var curatedSection: some View {
        VStack(alignment: .leading, spacing: AURASpacing.sm) {
            SectionHeader(title: "Curated for you")
                .padding(.horizontal, AURASpacing.md)
            TrackShelf(tracks: viewModel.curated) { track in
                playback.play(track: track, in: viewModel.curated)
            }
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

    private var artistsSection: some View {
        VStack(alignment: .leading, spacing: AURASpacing.sm) {
            SectionHeader(title: "Recommended artists")
                .padding(.horizontal, AURASpacing.md)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AURASpacing.lg) {
                    ForEach(viewModel.recommendedArtists) { artist in
                        VStack(spacing: AURASpacing.xxs) {
                            ArtworkView(seed: artist.id, cornerRadius: AURARadius.pill)
                                .frame(width: 84, height: 84)
                                .clipShape(Circle())
                            Text(artist.name)
                                .font(AURAType.caption)
                                .foregroundStyle(AURAColor.bone)
                                .lineLimit(1)
                                .frame(width: 84)
                        }
                        .accessibilityElement(children: .combine)
                    }
                }
                .padding(.horizontal, AURASpacing.md)
            }
        }
    }
}
