//
//  TellerProfileView.swift
//  OracleBrew
//
//  Full oracle profile: hero portrait, stats, topics, About, Reviews.
//  Reached from the Fortune Tellers list; "Continue with Oracle" selects and
//  advances the reading flow.
//

import SwiftUI

struct TellerProfileView: View {
    let teller: FortuneTeller
    let onContinue: () -> Void
    let onBack: () -> Void

    var body: some View {
        ZStack(alignment: .top) {
            Pigment.background.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    hero
                    details
                        .padding(.horizontal, 20)
                        .padding(.top, -70)
                        .padding(.bottom, 120)
                }
            }
            .ignoresSafeArea(edges: .top)

            backButton

            VStack {
                Spacer()
                PrimaryButton(title: "teller.continue", action: onContinue)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 8)
                    .background(
                        LinearGradient(colors: [Pigment.background.opacity(0), Pigment.background],
                                       startPoint: .top, endPoint: .bottom)
                        .frame(height: 120).allowsHitTesting(false),
                        alignment: .bottom
                    )
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var hero: some View {
        Image(teller.portrait)
            .resizable()
            .scaledToFill()
            .frame(height: 360)
            .frame(maxWidth: .infinity)
            .clipped()
            .overlay(alignment: .bottom) {
                LinearGradient(colors: [Pigment.background.opacity(0), Pigment.background],
                               startPoint: .top, endPoint: .bottom)
                    .frame(height: 180)
            }
            .allowsHitTesting(false)
    }

    private var details: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(teller.name)
                        .font(Lettering.displayMedium(32))
                        .foregroundStyle(Pigment.cream)
                    Text(teller.title)
                        .font(Lettering.body(14))
                        .foregroundStyle(Pigment.cream.opacity(0.4))
                }
                HStack(spacing: 20) {
                    RatingLabel(rating: teller.rating, starSize: 20, textSize: 16)
                    Text("teller.sessions \(teller.sessions)")
                        .font(Lettering.body(14)).foregroundStyle(Pigment.cream.opacity(0.4))
                    Text("teller.reviews \(teller.reviewCount)")
                        .font(Lettering.body(14)).foregroundStyle(Pigment.cream.opacity(0.4))
                }
                FlowLayout(spacing: 8) {
                    ForEach(teller.topics, id: \.self) { TopicChip(text: $0) }
                }
            }

            section(title: "teller.about") {
                Text(teller.bio)
                    .font(Lettering.body(14))
                    .foregroundStyle(Pigment.cream.opacity(0.6))
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }

            section(title: "teller.reviews_heading") {
                VStack(spacing: 8) {
                    ForEach(teller.reviews) { ReviewCard(review: $0) }
                }
            }
        }
    }

    private func section<Content: View>(title: LocalizedStringKey, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(Lettering.displayMedium(18))
                .foregroundStyle(Pigment.cream)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var backButton: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Pigment.cream)
                    .frame(width: Cadence.tapTarget, height: Cadence.tapTarget)
                    .background(Circle().fill(Pigment.surface))
                    .contentShape(Circle())
            }
            .buttonStyle(.plain)
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}
