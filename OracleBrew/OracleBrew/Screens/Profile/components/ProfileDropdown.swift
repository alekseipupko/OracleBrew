import SwiftUI

/// Field-styled shell shared by the text field and every dropdown selector.
struct ProfileFieldBox<Content: View>: View {
    var radius: CGFloat = 12
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(.horizontal, 16)
            .frame(height: Cadence.tapTarget)
            .background(RoundedRectangle(cornerRadius: radius).fill(Pigment.settingsCard))
            .overlay(RoundedRectangle(cornerRadius: radius).strokeBorder(Pigment.fieldBorder, lineWidth: 1))
    }
}

/// One row inside an expanded dropdown — label plus a check when it's current.
struct DropdownRow: View {
    let label: String
    let isSelected: Bool
    let showsDivider: Bool
    let action: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Button(action: action) {
                HStack(spacing: 0) {
                    Text(label)
                        .font(Lettering.display(14))
                        .foregroundStyle(isSelected ? Pigment.accent : Pigment.cream)
                    Spacer()
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Pigment.accent)
                    }
                }
                .padding(.horizontal, 16)
                .frame(height: 40)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if showsDivider {
                Rectangle().fill(Color.white.opacity(0.06)).frame(height: 1)
            }
        }
    }
}

/// Expanded list under a selector. Scrolls once past `maxVisible` rows so a
/// long list (countries) can't run off the screen.
struct DropdownOverlay<Item: Identifiable, Label: View>: View {
    let items: [Item]
    let isSelected: (Item) -> Bool
    let onPick: (Item) -> Void
    @ViewBuilder let label: (Item) -> Label

    var maxVisible: Int = 5
    private let rowHeight: CGFloat = 40

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    VStack(spacing: 0) {
                        Button { onPick(item) } label: {
                            HStack(spacing: 0) {
                                label(item)
                                Spacer()
                                if isSelected(item) {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundStyle(Pigment.accent)
                                }
                            }
                            .padding(.horizontal, 16)
                            .frame(height: rowHeight)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)

                        if index < items.count - 1 {
                            Rectangle().fill(Color.white.opacity(0.06)).frame(height: 1)
                        }
                    }
                }
            }
        }
        .frame(height: min(CGFloat(max(items.count, 1)), CGFloat(maxVisible)) * rowHeight)
        .background(RoundedRectangle(cornerRadius: 12).fill(Pigment.settingsCard))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Pigment.fieldBorder, lineWidth: 1))
    }
}

/// Chevron that flips when its dropdown opens.
struct DropdownChevron: View {
    let isOpen: Bool
    var size: CGFloat = 14

    var body: some View {
        Image(systemName: "chevron.down")
            .font(.system(size: size - 2, weight: .medium))
            .foregroundStyle(Pigment.fieldMuted)
            .rotationEffect(.degrees(isOpen ? 180 : 0))
            .animation(.easeInOut(duration: 0.2), value: isOpen)
    }
}
