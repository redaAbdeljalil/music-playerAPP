import SwiftUI

struct TrackRow: View {
    let track: Track
    var isActive: Bool = false
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AURASpacing.sm) {
                ArtworkView(seed: track.artworkSeed, cornerRadius: AURARadius.sm)
                    .frame(width: 48, height: 48)

                VStack(alignment: .leading, spacing: 2) {
                    Text(track.title)
                        .font(AURAType.body)
                        .foregroundStyle(isActive ? AURAColor.ember : AURAColor.bone)
                        .lineLimit(1)
                    Text(track.artistName)
                        .font(AURAType.caption)
                        .foregroundStyle(AURAColor.ash)
                        .lineLimit(1)
                }

                Spacer()

                if isActive {
                    Image(systemName: "waveform")
                        .font(.system(size: 13))
                        .foregroundStyle(AURAColor.ember)
                } else {
                    Text(track.duration.mmss)
                        .font(AURAType.caption)
                        .foregroundStyle(AURAColor.ash)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(track.title), \(track.artistName)")
        .accessibilityAddTraits(isActive ? [.isButton, .isSelected] : .isButton)
    }
}
