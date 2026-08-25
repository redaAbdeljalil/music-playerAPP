import UIKit

/// SwiftUI's `.sensoryFeedback()` modifier requires iOS 17; AURA targets
/// iOS 16, so `UIFeedbackGenerator` is the one place this project reaches
/// into UIKit. This is exactly the "absolutely required" exception the
/// spec allows for — everything else in the app is pure SwiftUI.
enum HapticsManager {
    static func tap() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    static func selection() {
        UISelectionFeedbackGenerator().selectionChanged()
    }

    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}
