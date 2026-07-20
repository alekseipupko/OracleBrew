import SwiftUI

struct SettingsButton: View {
    @Environment(Pathfinder.self) private var router

    var body: some View {
        Button {
            router.push(.settings)
        } label: {
            Image(systemName: "gearshape")
                .font(.system(size: 18))
                .foregroundStyle(Pigment.cream)
                .frame(width: Cadence.tapTarget, height: Cadence.tapTarget)
                .background(Circle().fill(Pigment.surface))
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
    }
}
