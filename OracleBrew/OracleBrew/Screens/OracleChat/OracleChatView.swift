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
    let thread: ChatThread
    let userName: String
    let onClose: () -> Void

    @State private var draftText = ""
    @State private var loading = false
    @State private var sending = false
    @State private var sendFailed = false
    @FocusState private var inputFocused: Bool

    private let repository = ChatRepository()

    private var teller: FortuneTeller { thread.teller }
    private var draft: ReadingDraft? { thread.draftContext }

    var body: some View {
        ZStack(alignment: .top) {
            Pigment.background.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 12) {
                            ForEach(thread.messages) { ChatBubble(message: $0).id($0.id) }
                            if sending { TypingBubble().id("typing") }
                        }
                        .padding(.vertical, 16)
                    }
                    .overlay { if loading { ProgressView().tint(Pigment.accent) } }
                    .onChange(of: thread.messages.count) { scrollToBottom(proxy) }
                    .onChange(of: sending) { scrollToBottom(proxy) }
                }
                if !thread.quickQuestions.isEmpty { quickChips }
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
        guard thread.backendID == nil else { return }
        loading = true
        defer { loading = false }
        do {
            let oracleID = Int(teller.id) ?? 0
            let created = try await repository.createOrResume(oracleID: oracleID, readingID: draft?.readingID)
            thread.backendID = created.id
            let detail = try await repository.detail(id: created.id)
            thread.messages = (detail.messages ?? []).map(ChatMapper.message)
            thread.quickQuestions = detail.quickQuestions ?? []
        } catch {
            sendFailed = true
        }
    }

    private var header: some View {
        HStack(spacing: 12) {
            Group {
                if let url = teller.portraitURL, !url.isEmpty {
                    RemoteImage(urlString: url, cornerRadius: 22)
                } else {
                    Image(teller.portrait).resizable().scaledToFill()
                }
            }
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
                ForEach(thread.quickQuestions, id: \.self) { question in
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
