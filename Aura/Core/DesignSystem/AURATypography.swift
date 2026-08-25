import SwiftUI

/// AURA pairs a serif display face (San Francisco's "New York" design,
/// native to iOS — no bundled fonts required) for editorial, emotional
/// moments with the standard system sans for UI chrome and metadata.
/// This is the single biggest lever in making the app feel like a
/// magazine rather than a dashboard — use `hero`/`display`/`title`
/// for anything that should feel considered, and the sans tokens for
/// anything that should feel like an interface.
enum AURAType {
    /// Greetings, the Discover headline — the largest editorial moment.
    static let hero = Font.system(size: 34, weight: .semibold, design: .serif)

    /// Featured/section titles, mood tile names, Now Playing track title.
    static let display = Font.system(size: 26, weight: .semibold, design: .serif)

    /// Screen and section headers.
    static let title = Font.system(size: 20, weight: .medium, design: .serif)

    /// Emphasized UI text that isn't a headline (row titles, buttons).
    static let headline = Font.system(size: 17, weight: .medium, design: .default)

    /// Default body / row text.
    static let body = Font.system(size: 15, weight: .regular, design: .default)

    /// Metadata — artist names, durations, timestamps.
    static let caption = Font.system(size: 13, weight: .medium, design: .default)

    /// Uppercase kickers and micro-labels ("CONTINUE LISTENING", tab labels).
    static let label = Font.system(size: 11, weight: .semibold, design: .default)
}
