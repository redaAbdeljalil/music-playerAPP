import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: AURASpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 32, weight: .light))
                .foregroundStyle(AURAColor.ash)
            Text(title)
                .font(AURAType.headline)
                .foregroundStyle(AURAColor.bone)
            Text(message)
                .font(AURAType.body)
                .foregroundStyle(AURAColor.ash)
                .multilineTextAlignment(.center)
        }
        .padding(AURASpacing.xl)
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }
}
