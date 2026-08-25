import SwiftUI

extension View {
    func auraShadow(_ token: AURAShadowToken) -> some View {
        self.shadow(color: token.color, radius: token.radius, x: token.x, y: token.y)
    }
}
