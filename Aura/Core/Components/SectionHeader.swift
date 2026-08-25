import SwiftUI

struct SectionHeader: View {
    let title: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(AURAType.title)
                .foregroundStyle(AURAColor.bone)

            Spacer()

            if let actionTitle, let action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(AURAType.caption)
                        .foregroundStyle(AURAColor.ember)
                }
                .buttonStyle(.plain)
            }
        }
        .accessibilityAddTraits(.isHeader)
    }
}
