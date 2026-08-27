import UIKit

/// Resolves a catalog asset name (e.g. "artist_soolking") to a real bundled image, if one has
/// been added. Tries the dedicated Resources folders first, then a flat lookup, then the asset
/// catalog — covering however Xcode ends up laying files out — and returns nil (never crashes)
/// if nothing is found, so ArtworkView can fall back to generated art.
enum ArtworkResolver {
    private static let imageExtensions = ["jpg", "jpeg", "png", "heic"]
    private static let searchDirectories: [String?] = ["Artists", "Albums", nil]

    static func image(named name: String) -> UIImage? {
        for directory in searchDirectories {
            for ext in imageExtensions {
                if let url = Bundle.main.url(forResource: name, withExtension: ext, subdirectory: directory),
                   let image = UIImage(contentsOfFile: url.path) {
                    return image
                }
            }
        }
        // Last resort: an asset catalog entry, in case one gets added later.
        return UIImage(named: name)
    }

    /// Extracts the hue component (0...1) from a "RRGGBB" hex string, for tinting generated art
    /// with an artist's signature color instead of a purely random one.
    static func hue(fromHex hex: String) -> Double? {
        let sanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        guard Scanner(string: sanitized).scanHexInt64(&rgb) else { return nil }
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        var h: CGFloat = 0, s: CGFloat = 0, v: CGFloat = 0, a: CGFloat = 0
        UIColor(red: r, green: g, blue: b, alpha: 1).getHue(&h, saturation: &s, brightness: &v, alpha: &a)
        return Double(h)
    }
}
