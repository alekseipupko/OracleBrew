import SwiftUI

struct EmptyState: View {
    let icon: String
    let headline: LocalizedStringKey
    let subtitle: LocalizedStringKey
    var cta: (title: LocalizedStringKey, action: () -> Void)?

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                Image(systemName: icon)
                    .font(.system(size: 40, weight: .light))
                    .foregroundStyle(Pigment.accent)
                    .frame(width: 100, height: 100)
                    .background(Circle().fill(Pigment.accent.opacity(0.1)))

                VStack(spacing: 8) {
                    Text(headline)
                        .font(Lettering.displayMedium(20))
                        .foregroundStyle(Pigment.cream)
                    Text(subtitle)
                        .font(Lettering.body(14))
                        .foregroundStyle(Pigment.cream.opacity(0.4))
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)
                }
            }

            Spacer()

            if let cta {
                PrimaryButton(title: cta.title, action: cta.action)
                    .padding(.bottom, 4)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
