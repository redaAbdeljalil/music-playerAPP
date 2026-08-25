import SwiftUI

struct MoodTile: View {
    let mood: Mood
    var height: CGFloat = 160

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            ArtworkView(seed: mood.artworkSeed, cornerRadius: AURARadius.lg)

            LinearGradient(
                colors: [.clear, Color.black.opacity(0.6)],
                startPoint: .center,
                endPoint: .bottom
            )
            .clipShape(RoundedRectangle(cornerRadius: AURARadius.lg, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text(mood.name)
                    .font(AURAType.display)
                    .foregroundStyle(.white)
                Text(mood.descriptor)
                    .font(AURAType.caption)
                    .foregroundStyle(.white.opacity(0.75))
                    .lineLimit(1)
            }
            .padding(AURASpacing.md)
        }
        .frame(height: height)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(mood.name). \(mood.descriptor)")
        .accessibilityAddTraits(.isButton)
    }
}
