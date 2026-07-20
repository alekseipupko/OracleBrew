import SwiftUI

struct StepDots: View {
    let current: Int          // 1-based
    var total: Int = 4

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...total, id: \.self) { i in
                Capsule()
                    .fill(i <= current ? Pigment.cream : Pigment.cream.opacity(0.2))
                    .frame(width: i == current ? 24 : 8, height: 8)
            }
        }
    }
}
