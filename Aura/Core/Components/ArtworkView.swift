import SwiftUI
import UIKit

/// Renders real catalog artwork when it's been added to the project; otherwise renders a
/// generated abstract placeholder so nothing ever shows broken/missing art.
///
/// `seed` drives the placeholder's shape (same seed → same gradient, always) — pass an album's
/// id for track artwork so every track on an album shares one family of placeholder art, the
/// way real cover art would. `tintHex`, when provided, anchors the placeholder's base hue to an
/// artist's signature color instead of a fully random one, so an artist's world reads as
/// consistent even before real photos are added.
struct ArtworkView: View {
    let assetName: String?
    let seed: String
    var tintHex: String? = nil
    var cornerRadius: CGFloat = AURARadius.md

    private var resolvedImage: UIImage? {
        guard let assetName else { return nil }
        return ArtworkResolver.image(named: assetName)
    }

    private var hashValue: Int {
        // djb2 string hash
        var hash = 5381
        for scalar in seed.unicodeScalars {
            hash = ((hash << 5) &+ hash) &+ Int(scalar.value)
        }
        return abs(hash)
    }

    private var baseHue: Double {
        if let tintHex, let hue = ArtworkResolver.hue(fromHex: tintHex) {
            return hue
        }
        return Double(hashValue % 360) / 360.0
    }

    private var secondaryHue: Double {
        let spread = 0.08 + (Double(hashValue % 100) / 100.0) * 0.14
        return (baseHue + spread).truncatingRemainder(dividingBy: 1.0)
    }

    private var saturationJitter: Double {
        0.5 + Double((hashValue / 7) % 18) / 100.0
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let resolvedImage {
                    Image(uiImage: resolvedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                } else {
                    AURAColor.ink
                    RadialGradient(
                        colors: [Color(hue: baseHue, saturation: saturationJitter, brightness: 0.82), .clear],
                        center: UnitPoint(x: 0.28, y: 0.24),
                        startRadius: 0,
                        endRadius: geometry.size.width * 0.9
                    )
                    RadialGradient(
                        colors: [Color(hue: secondaryHue, saturation: min(saturationJitter + 0.1, 0.85), brightness: 0.64), .clear],
                        center: UnitPoint(x: 0.78, y: 0.82),
                        startRadius: 0,
                        endRadius: geometry.size.width
                    )
                }
            }
        }
        .aspectRatio(1, contentMode: .fill)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .accessibilityHidden(true)
    }
}
