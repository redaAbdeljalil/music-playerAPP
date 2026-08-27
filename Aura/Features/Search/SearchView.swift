import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @EnvironmentObject private var playback: PlaybackManager
    @FocusState private var isFieldFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchField

                ScrollView {
                    VStack(alignment: .leading, spacing: AURASpacing.lg) {
                        if viewModel.query.trimmingCharacters(in: .whitespaces).isEmpty {
                            suggestionsContent
                        } else if viewModel.results.isEmpty {
                            EmptyStateView(
                                icon: AURAIcon.noResults,
                                title: "No results",
                                message: "No matches for \u{201C}\(viewModel.query)\u{201D}. Try a different mood, artist, or title."
                            )
                            .padding(.top, AURASpacing.xxl)
                        } else {
                            resultsContent
                        }
                    }
                    .padding(.horizontal, AURASpacing.md)
                    .padding(.top, AURASpacing.md)
                    .padding(.bottom, AURASpacing.xxxl)
                }
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

    // MARK: - Search field

    private var searchField: some View {
        HStack(spacing: AURASpacing.xs) {
            Image(systemName: AURAIcon.search)
                .foregroundStyle(AURAColor.ash)

            TextField("", text: $viewModel.query, prompt: Text("Songs, artists, albums").foregroundStyle(AURAColor.ash))
                .foregroundStyle(AURAColor.bone)
                .focused($isFieldFocused)
                .submitLabel(.search)
                .onSubmit { viewModel.performSearch() }
                .onChange(of: viewModel.query) { _ in viewModel.performSearch() }
                .accessibilityLabel("Search songs, artists, and albums")

            if !viewModel.query.isEmpty {
                Button {
                    viewModel.clearQuery()
                } label: {
                    Image(systemName: AURAIcon.clear)
                        .foregroundStyle(AURAColor.ash)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Clear search")
            }
        }
        .padding(.horizontal, AURASpacing.sm)
        .padding(.vertical, AURASpacing.xs)
        .background(RoundedRectangle(cornerRadius: AURARadius.md, style: .continuous).fill(AURAColor.inkElevated))
        .padding(.horizontal, AURASpacing.md)
        .padding(.top, AURASpacing.sm)
    }

    // MARK: - Suggestions (empty query state)

    private var suggestionsContent: some View {
        VStack(alignment: .leading, spacing: AURASpacing.lg) {
            if !viewModel.recentSearches.isEmpty {
                VStack(alignment: .leading, spacing: AURASpacing.sm) {
                    SectionHeader(title: "Recent")
                    ForEach(viewModel.recentSearches, id: \.self) { term in
                        Button {
                            viewModel.selectSuggestion(term)
                        } label: {
                            HStack {
                                Image(systemName: AURAIcon.clock)
                                    .foregroundStyle(AURAColor.ash)
                                Text(term)
                                    .foregroundStyle(AURAColor.bone)
                                Spacer()
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            VStack(alignment: .leading, spacing: AURASpacing.sm) {
                SectionHeader(title: "Trending")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AURASpacing.xs) {
                        ForEach(viewModel.trendingSearches, id: \.self) { term in
                            Button {
                                viewModel.selectSuggestion(term)
                            } label: {
                                Text(term)
                                    .font(AURAType.caption)
                                    .foregroundStyle(AURAColor.bone)
                                    .padding(.horizontal, AURASpacing.sm)
                                    .padding(.vertical, AURASpacing.xs)
                                    .background(Capsule().fill(AURAColor.inkElevated))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Results

    private var resultsContent: some View {
        VStack(alignment: .leading, spacing: AURASpacing.lg) {
            if !viewModel.results.tracks.isEmpty {
                VStack(alignment: .leading, spacing: AURASpacing.sm) {
                    SectionHeader(title: "Songs")
                    ForEach(viewModel.results.tracks) { track in
                        TrackRow(track: track, isActive: playback.isCurrentTrack(track)) {
                            playback.play(track: track, in: viewModel.results.tracks)
                        }
                    }
                }
            }

            if !viewModel.results.artists.isEmpty {
                VStack(alignment: .leading, spacing: AURASpacing.sm) {
                    SectionHeader(title: "Artists")
                    ForEach(viewModel.results.artists) { artist in
                        NavigationLink(value: artist) {
                            HStack(spacing: AURASpacing.sm) {
                                ArtworkView(
                                    assetName: artist.imageAssetName,
                                    seed: artist.id,
                                    tintHex: artist.accentColorHex,
                                    cornerRadius: AURARadius.md
                                )
                                .frame(width: 40, height: 40)
                                Text(artist.name)
                                    .foregroundStyle(AURAColor.bone)
                                Spacer()
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            if !viewModel.results.albums.isEmpty {
                VStack(alignment: .leading, spacing: AURASpacing.sm) {
                    SectionHeader(title: "Albums")
                    ForEach(viewModel.results.albums) { album in
                        NavigationLink(value: album) {
                            HStack(spacing: AURASpacing.sm) {
                                ArtworkView(assetName: album.artworkAssetName, seed: album.id, cornerRadius: AURARadius.sm)
                                    .frame(width: 40, height: 40)
                                VStack(alignment: .leading, spacing: 1) {
                                    Text(album.title).foregroundStyle(AURAColor.bone)
                                    Text(album.artistName).font(AURAType.caption).foregroundStyle(AURAColor.ash)
                                }
                                Spacer()
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            if !viewModel.results.playlists.isEmpty {
                VStack(alignment: .leading, spacing: AURASpacing.sm) {
                    SectionHeader(title: "Playlists")
                    ForEach(viewModel.results.playlists) { playlist in
                        HStack(spacing: AURASpacing.sm) {
                            ArtworkView(assetName: playlist.imageAssetName, seed: playlist.artworkSeed, cornerRadius: AURARadius.sm)
                                .frame(width: 40, height: 40)
                            VStack(alignment: .leading, spacing: 1) {
                                Text(playlist.title).foregroundStyle(AURAColor.bone)
                                Text(playlist.subtitle).font(AURAType.caption).foregroundStyle(AURAColor.ash)
                            }
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}
