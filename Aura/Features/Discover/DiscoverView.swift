import SwiftUI

struct DiscoverView: View {
    @StateObject private var viewModel = DiscoverViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: AURASpacing.md),
        GridItem(.flexible(), spacing: AURASpacing.md)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AURASpacing.lg) {
                    VStack(alignment: .leading, spacing: AURASpacing.xxs) {
                        Text("Discover")
                            .font(AURAType.hero)
                            .foregroundStyle(AURAColor.bone)
                        Text("Find your atmosphere.")
                            .font(AURAType.body)
                            .foregroundStyle(AURAColor.ash)
                    }
                    .padding(.horizontal, AURASpacing.md)
                    .padding(.top, AURASpacing.sm)

                    LazyVGrid(columns: columns, spacing: AURASpacing.md) {
                        ForEach(Array(viewModel.moods.enumerated()), id: \.element.id) { index, mood in
                            NavigationLink(value: mood) {
                                MoodTile(mood: mood, height: index.isMultiple(of: 2) ? 200 : 150)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, AURASpacing.md)
                }
                .padding(.bottom, AURASpacing.xxxl)
            }
            .background(AURAColor.ink.ignoresSafeArea())
            .navigationDestination(for: Mood.self) { mood in
                // NavigationStack destinations inherit environment objects
                // automatically from the presenting hierarchy (unlike
                // .sheet(), this isn't a separate presentation context),
                // so MoodDetailView's own @EnvironmentObject picks up
                // PlaybackManager from RootView without any extra wiring.
                MoodDetailView(mood: mood, tracks: viewModel.tracks(for: mood))
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}
