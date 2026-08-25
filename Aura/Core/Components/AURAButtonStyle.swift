import SwiftUI
/// deliberately print-poster-flat rather than glossy.
struct AURAPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AURAType.headline)
            .foregroundStyle(AURAColor.ink)
            .padding(.horizontal, AURASpacing.lg)
            .padding(.vertical, AURASpacing.sm)
            .background(
                Capsule(style: .continuous).fill(AURAColor.bone)
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(AURAMotion.quick, value: configuration.isPressed)
    }
}

struct AURACircularButtonStyle: ButtonStyle {
    var size: CGFloat = 64

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: size, height: size)
            .background(Circle().fill(AURAColor.bone))
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .animation(AURAMotion.quick, value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == AURAPrimaryButtonStyle {
    static var auraPrimary: AURAPrimaryButtonStyle { AURAPrimaryButtonStyle() }
}

extension ButtonStyle where Self == AURACircularButtonStyle {
    static func auraCircular(size: CGFloat = 64) -> AURACircularButtonStyle {
        AURACircularButtonStyle(size: size)
    }
}
