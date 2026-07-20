//
//  OracleChatView.swift
//  OracleBrew
//
//  In-character chat with the chosen oracle. Canned replies (ChatEngine);
//  remembers reading context (drink/topic) when reached from a finished
//  reading, greets generically when entered directly from the Brew tab.
//

import SwiftUI

/// Wraps an oracle for a view-only profile push from a chat, so it doesn't
/// collide with the selection-mode FortuneTeller destination in the reading flow.
struct TellerPeek: Hashable {
    let teller: FortuneTeller
}

struct OracleChatView: View {
    let thread: ChatThread
    let userName: String
    let onClose: () -> Void
    /// Opens the oracle's profile (view-only) when the header portrait is tapped.
    var onOpenProfile: (() -> Void)? = nil
    /// Returns to the reading this chat grew out of (post-reading chat only).
    var onReturnToReading: (() -> Void)? = nil

    @State private var draftText = ""
    @State private var loading = false
    @State private var sending = false
    @State private var sendFailed = false
    @State private var chipsHidden = false
    @FocusState private var inputFocused: Bool

    private let repository = ChatRepository()

    private var teller: FortuneTeller { thread.teller }
    private var draft: ReadingDraft? { thread.draftContext }

    var body: some View {
        ZStack(alignment: .top) {
            ChatBackground()

            VStack(spacing: 0) {
                header
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 12) {
                            if let reading = draft?.reading, let onReturnToReading {
                                readingCard(reading, action: onReturnToReading)
                            }
                            if !thread.messages.isEmpty { dateDivider }
                            ForEach(thread.messages) { ChatBubble(message: $0).id($0.id) }
                            if sending { TypingBubble().id("typing") }
                        }
                        .padding(.vertical, 16)
                    }
                    .overlay { if loading { ProgressView().tint(Pigment.accent) } }
                    .onChange(of: thread.messages.count) { scrollToBottom(proxy) }
                    .onChange(of: sending) { scrollToBottom(proxy) }
                }
                if !thread.quickQuestions.isEmpty && !chipsHidden { quickMenu }
                inputBar
            }
            .padding(.horizontal, 20)
        }
        .toolbar(.hidden, for: .navigationBar)
        .task { await load() }
        .alert("chat.send_failed.title", isPresented: $sendFailed) {
            Button("common.ok", role: .cancel) {}
        } message: {
            Text("chat.send_failed.message")
        }
    }

    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        if sending {
            withAnimation { proxy.scrollTo("typing", anchor: .bottom) }
        } else if let last = thread.messages.last {
            withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
        }
    }

    private func load() async {
        // Already populated (returning to an open thread) — nothing to do.
        guard thread.messages.isEmpty, !loading else { return }
        loading = true
        defer { loading = false }
        do {
            // A thread opened from the list already knows its server id; one
            // opened fresh gets created-or-resumed first.
            let chatID: Int
            if let id = thread.backendID {
                chatID = id
            } else {
                let oracleID = Int(teller.id) ?? 0
                let created = try await repository.createOrResume(oracleID: oracleID, readingID: draft?.readingID)
                thread.backendID = created.id
                chatID = created.id
            }
            let detail = try await repository.detail(id: chatID)
            thread.messages = (detail.messages ?? []).map(ChatMapper.message)
            thread.quickQuestions = detail.quickQuestions ?? []
        } catch {
            sendFailed = true
        }
    }

    // Back on the left, the oracle centred — matching the design (was a
    // portrait-left / close-right layout).
    private var header: some View {
        ZStack {
            Button { onOpenProfile?() } label: {
                HStack(spacing: 12) {
                    Group {
                        if let url = teller.portraitURL, !url.isEmpty {
                            RemoteImage(urlString: url, cornerRadius: 24)
                        } else {
                            Image(teller.portrait).resizable().scaledToFill()
                        }
                    }
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())
                    VStack(alignment: .leading, spacing: 2) {
                        Text(teller.name)
                            .font(Lettering.displayMedium(18))
                            .foregroundStyle(Pigment.cream)
                        Text(teller.title)
                            .font(Lettering.body(12))
                            .foregroundStyle(Pigment.cream.opacity(0.5))
                    }
                }
            }
            .buttonStyle(.plain)
            .disabled(onOpenProfile == nil)

            HStack {
                Button(action: onClose) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Pigment.cream)
                        .frame(width: Cadence.tapTarget, height: Cadence.tapTarget)
                        .background(Circle().fill(Pigment.surface))
                }
                .buttonStyle(.plain)
                Spacer()
            }
        }
        .padding(.top, 4)
        .padding(.bottom, 8)
    }

    /// A tappable summary of the reading this chat came from — returns to the
    /// full result. Shown at the top of a post-reading chat.
    private func readingCard(_ reading: Reading, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: "cup.and.saucer.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(Pigment.accent)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Pigment.accent.opacity(0.15)))
                VStack(alignment: .leading, spacing: 2) {
                    Text("chat.reading_card")
                        .font(Lettering.bodyMedium(11))
                        .textCase(.uppercase)
                        .foregroundStyle(Pigment.accent)
                    Text(reading.advice)
                        .font(Lettering.body(13))
                        .foregroundStyle(Pigment.cream)
                        .lineLimit(1)
                }
                Spacer(minLength: 4)
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Pigment.cream.opacity(0.4))
            }
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 16).fill(Pigment.surface))
            .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(Pigment.accent.opacity(0.3), lineWidth: 1))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var dateDivider: some View {
        Text("chat.today")
            .font(Lettering.body(12))
            .foregroundStyle(Pigment.cream.opacity(0.4))
            .frame(maxWidth: .infinity)
            .padding(.top, 4)
    }

    /// The suggestions sit on their own tinted panel, and each one is shaped
    /// like a message the user is about to send — same gradient, same tail. The
    /// dismiss sits inside the panel's top-left corner.
    private var quickMenu: some View {
        VStack(alignment: .trailing, spacing: 10) {
            ForEach(thread.quickQuestions, id: \.self) { question in
                Button { send(question) } label: {
                    Text(question)
                        .font(Lettering.bodyMedium(14))
                        .foregroundStyle(Pigment.cream)
                        .multilineTextAlignment(.trailing)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Pigment.accentGradient)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .background(alignment: .bottomTrailing) {
                            BubbleTail(leading: false)
                                .fill(Pigment.accentGradient)
                                .frame(width: BubbleTail.size.width, height: BubbleTail.size.height)
                                .offset(x: 3)
                        }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .trailing)
        // A plain accent tint, as the design has it. Material was far heavier
        // than its 4pt backdrop blur and washed the panel grey.
        .background(RoundedRectangle(cornerRadius: 20).fill(Pigment.accent.opacity(0.15)))
        .overlay(alignment: .topLeading) { dismissHints }
        .padding(.bottom, 12)
    }

    private var dismissHints: some View {
        Button { withAnimation { chipsHidden = true } } label: {
            Image(systemName: "xmark")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Pigment.cream)
                .frame(width: 32, height: 32)
                .background(Circle().fill(Pigment.inkDeep))
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .padding(8)
    }

    private var inputBar: some View {
        HStack(spacing: 8) {
            TextField("chat.placeholder", text: $draftText, axis: .vertical)
                .font(Lettering.body(14))
                .foregroundStyle(Pigment.cream)
                .focused($inputFocused)
                .padding(.horizontal, 16)
                .frame(minHeight: 52)
                .background(Capsule().fill(Pigment.inkDeep))
                .overlay(Capsule().strokeBorder(Pigment.accent.opacity(0.4), lineWidth: 1))

            Button { send(draftText) } label: {
                Image("IconSend")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Pigment.cream)
                    .frame(width: 52, height: 52)
                    .background(Circle().fill(Pigment.accentGradient))
                    .overlay(Circle().strokeBorder(Pigment.cream.opacity(0.15), lineWidth: 1))
                    .shadow(color: Pigment.accent.opacity(0.3), radius: 3, y: 4)
                    .contentShape(Circle())
            }
            .buttonStyle(.plain)
            .disabled(draftText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .opacity(draftText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.4 : 1)
        }
        .padding(.bottom, 8)
    }

    private func send(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !sending, let chatID = thread.backendID else { return }

        thread.messages.append(ChatMessage(isFromUser: true, text: trimmed))
        draftText = ""
        inputFocused = false
        sending = true

        Task {
            defer { sending = false }
            do {
                let response = try await repository.send(chatID: chatID, text: trimmed)
                thread.messages.append(ChatMapper.message(response.assistantMessage))
                thread.lastUpdated = Date()
            } catch {
                // Drop the optimistic user bubble back into the input so nothing
                // is lost, and surface the failure.
                if thread.messages.last?.isFromUser == true { thread.messages.removeLast() }
                draftText = trimmed
                sendFailed = true
            }
        }
    }
}

/// Three-dot "oracle is typing" bubble shown while awaiting a reply.
private struct TypingBubble: View {
    @State private var phase = 0

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(Pigment.cream.opacity(phase == i ? 0.9 : 0.3))
                    .frame(width: 6, height: 6)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Capsule().fill(Pigment.surface))
        .frame(maxWidth: .infinity, alignment: .leading)
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .milliseconds(350))
                phase = (phase + 1) % 3
            }
        }
    }
}
