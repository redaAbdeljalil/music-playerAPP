import SwiftUI

/// Centralized animation curves. Motion in AURA should feel considered
/// and a little slow rather than snappy/bouncy everywhere — this is part
/// of what separates "premium" from "generic app" motion design.
enum AURAMotion {
    /// Button press feedback, icon swaps.
    static let quick = Animation.easeOut(duration: 0.2)

    /// Default transitions — tab switches, content changes.
    static let standard = Animation.easeInOut(duration: 0.35)

    /// Ambient / atmospheric movement (backgrounds, breathing artwork).
    static let slow = Animation.easeInOut(duration: 0.6)

    /// Mini player <-> Now Playing expansion, like-button pop.
    static let spring = Animation.spring(response: 0.45, dampingFraction: 0.82)
}
