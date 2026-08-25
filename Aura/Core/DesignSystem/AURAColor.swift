import SwiftUI

/// AURA's color language: near-black "ink" surfaces, warm bone text,
/// and a single warm accent ("ember") used sparingly for state and
/// interaction — never as decoration. Deliberately restrained: two
/// accents total, no neon, no rainbow gradients.
enum AURAColor {
    /// Primary background. Not true black — a soft, warm near-black.
    static let ink = Color(hex: "0B0B0C")

    /// Slightly raised surface, used for cards, rows, and the mini player.
    static let inkElevated = Color(hex: "161516")

    /// Primary text / foreground.
    static let bone = Color(hex: "F4EFE6")

    /// Secondary text — captions, metadata, inactive icons.
    static let ash = Color(hex: "9C9691")

    /// Primary accent. Used for active state, progress, and the like color —
    /// never for large fills or backgrounds.
    static let ember = Color(hex: "D98E4A")

    /// Secondary accent, reserved for rare emphasis (explicit content tags,
    /// energetic mood markers). Not used in the default component set.
    static let clay = Color(hex: "B3564A")

    /// Hairline dividers.
    static let line = Color.white.opacity(0.08)
}
