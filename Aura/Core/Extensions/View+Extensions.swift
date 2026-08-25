import SwiftUI

extension View {
    /// Applies a design-system shadow token in one call, e.g.
    /// `.auraShadow(AURAShadow.elevated)`.
    func auraShadow(_ token: AURAShadowToken) -> some View {
        self.shadow(color: token.color, radius: token.radius, x: token.x, y: token.y)
    }
}
