import SwiftUI

/// A deliberately original navigation treatment: icon-only tabs with a
/// thin sliding underline indicator (via `matchedGeometryEffect`) rather
/// than Apple's icon+label-always-visible tab bar. Flat ink background
/// with a single hairline divider — no blur/material, to keep the
/// editorial, non-glassy look the design system commits to.
struct AURATabBar: View {
    @Binding var selectedTab: AURATab
    @Namespace private var indicatorNamespace

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AURATab.allCases, id: \.self) { tab in
                tabButton(tab)
            }
        }
        .padding(.top, AURASpacing.sm)
        .padding(.bottom, AURASpacing.xxs)
        .background(
            AURAColor.ink
                .overlay(alignment: .top) {
                    Rectangle().fill(AURAColor.line).frame(height: 1)
                }
        )
    }

    private func tabButton(_ tab: AURATab) -> some View {
        Button {
            HapticsManager.selection()
            withAnimation(AURAMotion.spring) { selectedTab = tab }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundStyle(selectedTab == tab ? AURAColor.bone : AURAColor.ash)

                if selectedTab == tab {
                    Capsule()
                        .fill(AURAColor.ember)
                        .frame(width: 16, height: 3)
                        .matchedGeometryEffect(id: "tabIndicator", in: indicatorNamespace)
                } else {
                    Color.clear.frame(width: 16, height: 3)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(tab.title)
        .accessibilityAddTraits(selectedTab == tab ? [.isButton, .isSelected] : .isButton)
    }
}
