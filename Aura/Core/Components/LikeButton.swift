import SwiftUI

struct LikeButton: View {
    let isLiked: Bool
    let action: () -> Void

    @State private var isPulsing = false

    var body: some View {
        Button {
            action()
            HapticsManager.tap()
            triggerPulse()
        } label: {
            Image(systemName: isLiked ? AURAIcon.likeFilled : AURAIcon.like)
                .font(.system(size: 20))
                .foregroundStyle(isLiked ? AURAColor.ember : AURAColor.ash)
                .scaleEffect(isPulsing ? 1.3 : 1.0)
                .animation(AURAMotion.spring, value: isPulsing)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isLiked ? "Unlike" : "Like")
    }

    private func triggerPulse() {
        isPulsing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            isPulsing = false
        }
    }
}
