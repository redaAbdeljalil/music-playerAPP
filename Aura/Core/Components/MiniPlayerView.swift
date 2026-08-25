import SwiftUI

struct MiniPlayerView: View {
    @EnvironmentObject private var playback: PlaybackManager
    let namespace: Namespace.ID
    let onExpand: () -> Void

    var body: some View {
        if let track = playback.currentTrack {
            HStack(spacing: AURASpacing.sm) {
                ArtworkView(seed: track.artworkSeed, cornerRadius: AURARadius.sm)
                    .frame(width: 40, height: 40)
                    .matchedGeometryEffect(id: "playerArtwork", in: namespace)

                VStack(alignment: .leading, spacing: 1) {
                    Text(track.title)
                        .font(AURAType.caption)
                        .foregroundStyle(AURAColor.bone)
                        .lineLimit(1)
                    Text(track.artistName)
                        .font(AURAType.label)
                        .foregroundStyle(AURAColor.ash)
                        .lineLimit(1)
                }

                Spacer()

                Button {
                    playback.togglePlayPause()
                    HapticsManager.tap()
                } label: {
                    Image(systemName: playback.isPlaying ? AURAIcon.pause : AURAIcon.play)
                        .font(.system(size: 16))
                        .foregroundStyle(AURAColor.bone)
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(playback.isPlaying ? "Pause" : "Play")
            }
            .padding(.horizontal, AURASpacing.sm)
            .padding(.vertical, AURASpacing.xs)
            .background(
                RoundedRectangle(cornerRadius: AURARadius.md, style: .continuous)
                    .fill(AURAColor.inkElevated)
            )
            .overlay(alignment: .bottom) {
                GeometryReader { geometry in
                    Rectangle()
                        .fill(AURAColor.ember)
                        .frame(width: geometry.size.width * progressFraction, height: 2)
                }
                .frame(height: 2)
                .clipShape(RoundedRectangle(cornerRadius: AURARadius.md, style: .continuous))
            }
            .contentShape(Rectangle())
            .onTapGesture { onExpand() }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Now playing: \(track.title) by \(track.artistName)")
            .accessibilityHint("Double tap to open the full player")
        }
    }

    private var progressFraction: CGFloat {
        guard playback.duration > 0 else { return 0 }
        return CGFloat(playback.progress / playback.duration)
    }
}
