import SwiftUI

struct MoodDetailView: View {
    let mood: Mood
    let tracks: [Track]

    @EnvironmentObject private var playback: PlaybackManager

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AURASpacing.md) {
                ZStack(alignment: .bottomLeading) {
                    ArtworkView(assetName: mood.imageAssetName, seed: mood.artworkSeed, cornerRadius: 0)
                        .frame(height: 220)
                        .clipped()
                    LinearGradient(colors: [.clear, AURAColor.ink], startPoint: .center, endPoint: .bottom)
                        .frame(height: 220)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(mood.name)
                            .font(AURAType.hero)
                            .foregroundStyle(.white)
                        Text(mood.descriptor)
                            .font(AURAType.body)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .padding(AURASpacing.md)
                }

                Button {
                    if let first = tracks.first {
                        playback.play(track: first, in: tracks)
                    }
                } label: {
                    Label("Play", systemImage: AURAIcon.play)
                }
                .buttonStyle(.auraPrimary)
                .padding(.horizontal, AURASpacing.md)
                .disabled(tracks.isEmpty)

                LazyVStack(spacing: AURASpacing.xs) {
                    ForEach(Array(tracks.enumerated()), id: \.element.id) { index, track in
                        TrackRow(track: track, isActive: playback.isCurrentTrack(track), rank: index + 1) {
                            playback.play(track: track, in: tracks)
                        }
                    }
                }
                .padding(.horizontal, AURASpacing.md)
            }
            .padding(.bottom, AURASpacing.xxxl)
        }
        .background(AURAColor.ink.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(AURAColor.ink, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}
