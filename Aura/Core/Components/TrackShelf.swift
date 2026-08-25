import SwiftUI

struct TrackShelf: View {
    let tracks: [Track]
    var onSelect: (Track) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AURASpacing.md) {
                ForEach(tracks) { track in
                    Button {
                        onSelect(track)
                    } label: {
                        VStack(alignment: .leading, spacing: AURASpacing.xxs) {
                            ArtworkView(seed: track.artworkSeed)
                                .frame(width: 140, height: 140)
                            Text(track.title)
                                .font(AURAType.caption)
                                .foregroundStyle(AURAColor.bone)
                                .lineLimit(1)
                            Text(track.artistName)
                                .font(AURAType.label)
                                .foregroundStyle(AURAColor.ash)
                                .lineLimit(1)
                        }
                        .frame(width: 140, alignment: .leading)
                    }
                    .buttonStyle(.plain)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("\(track.title), \(track.artistName)")
                    .accessibilityAddTraits(.isButton)
                }
            }
            .padding(.horizontal, AURASpacing.md)
        }
    }
}
