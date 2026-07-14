//
//  OracleChatView.swift
//  OracleBrew
//
//  In-character chat with the chosen oracle. Canned replies (ChatEngine);
//  remembers reading context (drink/topic) when reached from a finished
//  reading, greets generically when entered directly from the Brew tab.
//

import SwiftUI

struct OracleChatView: View {
    let teller: FortuneTeller
    let draft: ReadingDraft?
    let userName: String
    let onClose: () -> Void

    @State private var messages: [ChatMessage] = []
    @State private var draftText = ""
    @FocusState private var inputFocused: Bool

    private var quickQuestions: [String] { ChatEngine.quickQuestions(hasReadingContext: draft?.topic != nil) }

    var body: some View {
        ZStack(alignment: .top) {
            Pigment.background.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 12) {
                            ForEach(messages) { ChatBubble(message: $0).id($0.id) }
                        }
                        .padding(.vertical, 16)
                    }
                    .onChange(of: messages.count) {
                        guard let last = messages.last else { return }
                        withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                    }
                }
                quickChips
                inputBar
            }
            .padding(.horizontal, 20)
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            guard messages.isEmpty else { return }
            messages.append(ChatMessage(isFromUser: false, text: ChatEngine.greeting(teller: teller, userName: userName, draft: draft)))
        }
    }

    private var header: some View {
        HStack(spacing: 12) {
            Image(teller.portrait)
                .resizable()
                .scaledToFill()
                .frame(width: 44, height: 44)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 2) {
                Text(teller.name)
                    .font(Lettering.displayMedium(18))
                    .foregroundStyle(Pigment.cream)
                Text(teller.title)
                    .font(Lettering.body(12))
                    .foregroundStyle(Pigment.cream.opacity(0.5))
            }
            Spacer()
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Pigment.cream)
                    .frame(width: Cadence.tapTarget, height: Cadence.tapTarget)
                    .background(Circle().fill(Pigment.surface))
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 4)
        .padding(.bottom, 8)
    }

    private var quickChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(quickQuestions, id: \.self) { question in
                    Button { send(question) } label: {
                        Text(question)
                            .font(Lettering.body(13))
                            .foregroundStyle(Pigment.cream)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Capsule().fill(Pigment.surface))
                            .overlay(Capsule().strokeBorder(Color.white.opacity(0.12), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 4)
        }
        .padding(.bottom, 8)
    }

    private var inputBar: some View {
        HStack(spacing: 8) {
            TextField("chat.placeholder", text: $draftText, axis: .vertical)
                .font(Lettering.body(15))
                .foregroundStyle(Pigment.cream)
                .focused($inputFocused)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Capsule().fill(Color(hex: 0x271C3E)))
                .overlay(Capsule().strokeBorder(Color.white.opacity(0.15), lineWidth: 1))

            Button { send(draftText) } label: {
                Image(systemName: "arrow.up")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Pigment.cardInk)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Pigment.accentGradient))
            }
            .buttonStyle(.plain)
            .disabled(draftText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .opacity(draftText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.4 : 1)
        }
        .padding(.bottom, 8)
    }

    private func send(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        messages.append(ChatMessage(isFromUser: true, text: trimmed))
        draftText = ""
        inputFocused = false
        messages.append(ChatMessage(isFromUser: false, text: ChatEngine.reply(to: trimmed, teller: teller, draft: draft)))
    }
}
