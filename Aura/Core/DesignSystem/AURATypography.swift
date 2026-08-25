import SwiftUI

enum AURAType {
    /// Greetings, the Discover headline — the largest editorial moment.
    static let hero = Font.system(size: 34, weight: .semibold, design: .serif)

    /// Featured/section titles, mood tile names, Now Playing track title.
    static let display = Font.system(size: 26, weight: .semibold, design: .serif)

    /// Screen and section headers.
    static let title = Font.system(size: 20, weight: .medium, design: .serif)

    static let headline = Font.system(size: 17, weight: .medium, design: .default)

    /// Default body / row text.
    static let body = Font.system(size: 15, weight: .regular, design: .default)

    /// Metadata
    static let caption = Font.system(size: 13, weight: .medium, design: .default)

    /// Uppercase kickers and micro-labels ("CONTINUE LISTENING", tab labels).
    static let label = Font.system(size: 11, weight: .semibold, design: .default)
}
