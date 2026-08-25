import SwiftUI

struct ArtworkView: View {
    let seed: String
    var cornerRadius: CGFloat = AURARadius.md

    private var hashValue: Int {
        // djb2 string hash
        var hash = 5381
        for scalar in seed.unicodeScalars {
            hash = ((hash << 5) &+ hash) &+ Int(scalar.value)
        }
        return abs(hash)
    }

    private var baseHue: Double {
        Double(hashValue % 360) / 360.0
    }

    private var secondaryHue: Double {
        (baseHue + 0.14).truncatingRemainder(dividingBy: 1.0)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AURAColor.ink
                RadialGradient(
                    colors: [Color(hue: baseHue, saturation: 0.55, brightness: 0.82), .clear],
                    center: UnitPoint(x: 0.28, y: 0.24),
                    startRadius: 0,
                    endRadius: geometry.size.width * 0.9
                )
                RadialGradient(
                    colors: [Color(hue: secondaryHue, saturation: 0.6, brightness: 0.66), .clear],
                    center: UnitPoint(x: 0.78, y: 0.82),
                    startRadius: 0,
                    endRadius: geometry.size.width
                )
            }
        }
        .aspectRatio(1, contentMode: .fill)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .accessibilityHidden(true)
    }
}
