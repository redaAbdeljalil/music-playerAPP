import SwiftUI
enum AURASpacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
    static let xxxl: CGFloat = 64
}

/// Deliberately restrained corner radii
enum AURARadius {
    static let sm: CGFloat = 4
    static let md: CGFloat = 10
    static let lg: CGFloat = 18
    static let pill: CGFloat = 999
}

struct AURAShadowToken {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

enum AURAShadow {
    static let soft = AURAShadowToken(color: .black.opacity(0.35), radius: 20, x: 0, y: 8)
    static let elevated = AURAShadowToken(color: .black.opacity(0.45), radius: 30, x: 0, y: 14)
}
