import SwiftUI

struct QueueSheetView: View {
    @EnvironmentObject private var playback: PlaybackManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: AURASpacing.xs) {
                    ForEach(playback.queue) { track in
                        TrackRow(
                            track: track,
                            isActive: playback.isCurrentTrack(track),
                            onTap: { playback.play(track: track, in: playback.queue) }
                        )
                    }
                }
                .padding(AURASpacing.md)
            }
            .background(AURAColor.ink.ignoresSafeArea())
            .navigationTitle("Queue")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(AURAColor.ember)
                }
            }
            .toolbarBackground(AURAColor.ink, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
