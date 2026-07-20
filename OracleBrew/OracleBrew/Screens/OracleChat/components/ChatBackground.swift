import SwiftUI

struct ChatBackground: View {
    var body: some View {
        Pigment.background
            .overlay {
                Image("ChatBackground")
                    .resizable()
                    .scaledToFill()
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)
    }
}
