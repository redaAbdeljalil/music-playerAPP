import SwiftUI

struct RootView: View {
    @StateObject private var playback = PlaybackManager()
    @StateObject private var libraryStore = UserLibraryStore()

    @State private var selectedTab: AURATab = .home
    @State private var isNowPlayingExpanded = false
    @Namespace private var playerNamespace

    private let library: MusicLibraryProviding = MockMusicLibraryService()

    var body: some View {
        ZStack {
            AURAColor.ink.ignoresSafeArea()

            // All four tabs stay alive at all times (opacity-toggled rather
            // than switched in/out of the tree) so each keeps its own
            // scroll position and navigation state across tab switches —
            // a plain `switch` here would reset every tab's @StateObject
            // every time the user left and came back to it.
            ZStack {
                HomeView()
                    .opacity(selectedTab == .home ? 1 : 0)
                    .allowsHitTesting(selectedTab == .home)
                    .accessibilityHidden(selectedTab != .home)

                DiscoverView()
                    .opacity(selectedTab == .discover ? 1 : 0)
                    .allowsHitTesting(selectedTab == .discover)
                    .accessibilityHidden(selectedTab != .discover)

                SearchView()
                    .opacity(selectedTab == .search ? 1 : 0)
                    .allowsHitTesting(selectedTab == .search)
                    .accessibilityHidden(selectedTab != .search)

                LibraryView()
                    .opacity(selectedTab == .library ? 1 : 0)
                    .allowsHitTesting(selectedTab == .library)
                    .accessibilityHidden(selectedTab != .library)
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 0) {
                    if playback.currentTrack != nil {
                        MiniPlayerView(namespace: playerNamespace) {
                            withAnimation(AURAMotion.spring) { isNowPlayingExpanded = true }
                        }
                        .padding(.horizontal, AURASpacing.sm)
                        .padding(.top, AURASpacing.xs)
                    }
                    AURATabBar(selectedTab: $selectedTab)
                }
                .background(AURAColor.ink)
            }

            if isNowPlayingExpanded, playback.currentTrack != nil {
                NowPlayingView(namespace: playerNamespace, isExpanded: $isNowPlayingExpanded)
                    .transition(.move(edge: .bottom))
                    .zIndex(2)
            }
        }
        .environmentObject(playback)
        .environmentObject(libraryStore)
        .onAppear(perform: configureOnLaunch)
    }

    private func configureOnLaunch() {
        playback.onTrackDidStart = { track in
            libraryStore.recordPlay(track)
        }
        libraryStore.seedDefaults(
            likedTracks: Array(library.allTracks().prefix(3)),
            savedAlbums: Array(library.allAlbums().prefix(2))
        )
    }
}
