import SwiftUI

struct TrackRow: View {
    let track: Track
    var isActive: Bool = false
    /// When set, shows an editorial rank numeral (album track number, or a Top 5 position)
    /// before the artwork instead of nothing.
    var rank: Int? = nil
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AURASpacing.sm) {
                if let rank {
                    Text("\(rank)")
                        .font(AURAType.numeral)
                        .foregroundStyle(isActive ? AURAColor.ember : AURAColor.ash)
                        .frame(width: 22, alignment: .trailing)
                }

                ArtworkView(assetName: track.artworkAssetName, seed: track.albumID, cornerRadius: AURARadius.sm)
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
        .accessibilityLabel(rankedAccessibilityLabel)
        .accessibilityAddTraits(isActive ? [.isButton, .isSelected] : .isButton)
    }

    private var rankedAccessibilityLabel: String {
        if let rank {
            return "\(rank). \(track.title), \(track.artistName)"
        }
        return "\(track.title), \(track.artistName)"
    }
}
