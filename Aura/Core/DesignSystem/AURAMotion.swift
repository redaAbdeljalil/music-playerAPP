import SwiftUI
enum AURAMotion {
    /// Button press feedback, icon swaps.
    static let quick = Animation.easeOut(duration: 0.2)

    /// Default transitions
    static let standard = Animation.easeInOut(duration: 0.35)

    /// Ambient / atmospheric movement (backgrounds, breathing artwork).
    static let slow = Animation.easeInOut(duration: 0.6)

    /// Mini player
    static let spring = Animation.spring(response: 0.45, dampingFraction: 0.82)
}
