import SwiftUI

struct LibraryView: View {
    @StateObject private var viewModel = LibraryViewModel()
    @EnvironmentObject private var playback: PlaybackManager
    @EnvironmentObject private var libraryStore: UserLibraryStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AURASpacing.xl) {
                    Text("Library")
                        .font(AURAType.hero)
                        .foregroundStyle(AURAColor.bone)
                        .padding(.horizontal, AURASpacing.md)

                    if !libraryStore.recentlyPlayed.isEmpty {
                        VStack(alignment: .leading, spacing: AURASpacing.sm) {
                            SectionHeader(title: "Recently played").padding(.horizontal, AURASpacing.md)
                            TrackShelf(tracks: libraryStore.recentlyPlayed) { track in
                                playback.play(track: track, in: libraryStore.recentlyPlayed)
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: AURASpacing.sm) {
                        SectionHeader(title: "Liked songs").padding(.horizontal, AURASpacing.md)
                        if libraryStore.likedTracks.isEmpty {
                            EmptyStateView(
                                icon: AURAIcon.emptyHeart,
                                title: "No liked songs yet",
                                message: "Tap the heart on any track to save it here."
                            )
                        } else {
                            LazyVStack(spacing: AURASpacing.xs) {
                                ForEach(libraryStore.likedTracks) { track in
                                    TrackRow(track: track, isActive: playback.isCurrentTrack(track)) {
                                        playback.play(track: track, in: libraryStore.likedTracks)
                                    }
                                }
                            }
                            .padding(.horizontal, AURASpacing.md)
                        }
                    }

                    if !libraryStore.savedAlbums.isEmpty {
                        VStack(alignment: .leading, spacing: AURASpacing.sm) {
                            SectionHeader(title: "Saved albums").padding(.horizontal, AURASpacing.md)
                            AlbumShelf(albums: libraryStore.savedAlbums)
                        }
                    }

                    VStack(alignment: .leading, spacing: AURASpacing.sm) {
                        SectionHeader(title: "Playlists").padding(.horizontal, AURASpacing.md)
                        LazyVStack(spacing: AURASpacing.xs) {
                            ForEach(viewModel.playlists) { playlist in
                                Button {
                                    let tracks = viewModel.tracks(for: playlist)
                                    if let first = tracks.first {
                                        playback.play(track: first, in: tracks)
                                    }
                                } label: {
                                    HStack(spacing: AURASpacing.sm) {
                                        ArtworkView(assetName: playlist.imageAssetName, seed: playlist.artworkSeed, cornerRadius: AURARadius.sm)
                                            .frame(width: 56, height: 56)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(playlist.title).foregroundStyle(AURAColor.bone)
                                            Text(playlist.subtitle)
                                                .font(AURAType.caption)
                                                .foregroundStyle(AURAColor.ash)
                                        }
                                        Spacer()
                                    }
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, AURASpacing.md)
                    }
                }
                .padding(.top, AURASpacing.sm)
                .padding(.bottom, AURASpacing.xxxl)
            }
            .background(AURAColor.ink.ignoresSafeArea())
            .navigationDestination(for: Album.self) { album in
                AlbumDetailView(album: album)
            }
            .navigationDestination(for: Artist.self) { artist in
                ArtistDetailView(artist: artist)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}
