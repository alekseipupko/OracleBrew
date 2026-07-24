import SwiftUI

/// Wraps an oracle for a view-only profile push from a chat, so it doesn't
/// collide with the selection-mode FortuneTeller destination in the reading flow.
struct TellerPeek: Hashable {
    let teller: FortuneTeller
}

/// Carries the reading card's bottom edge, in the scroll viewport's space, up
/// to the header so the cup shortcut can appear once the card scrolls off.
private struct CardOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .greatestFiniteMagnitude
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = min(value, nextValue())
    }
}

struct OracleChatView: View {
    let thread: ChatThread
    let onClose: () -> Void
    /// Opens the oracle's profile (view-only) when the header portrait is tapped.
    var onOpenProfile: (() -> Void)? = nil
    /// Returns to the reading this chat grew out of (post-reading chat only).
    var onReturnToReading: (() -> Void)? = nil

    @Environment(\.layoutDirection) private var layoutDirection

    @State private var draftText = ""
    @State private var loading = false
    @State private var sending = false
    @State private var sendFailed = false
    @State private var chipsHidden = false
    /// True once the reading card has scrolled up out of view — surfaces the
    /// cup shortcut in the header so the reading stays one tap away.
    @State private var readingCardOffscreen = false
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
                                    .background(GeometryReader { geo in
                                        Color.clear.preference(
                                            key: CardOffsetKey.self,
                                            value: geo.frame(in: .named("chatScroll")).maxY
                                        )
                                    })
                            }
                            if !thread.messages.isEmpty { dateDivider }
                            ForEach(thread.messages) { ChatBubble(message: $0).id($0.id) }
                            if sending { TypingBubble().id("typing") }
                        }
                        .padding(.vertical, 16)
                    }
                    .coordinateSpace(name: "chatScroll")
                    .overlay { if loading { ProgressView().tint(Pigment.accent) } }
                    .onChange(of: thread.messages.count) { scrollToBottom(proxy) }
                    .onChange(of: sending) { scrollToBottom(proxy) }
                    .onPreferenceChange(CardOffsetKey.self) { maxY in
                        // maxY is the card's bottom in the viewport; ≤0 means it
                        // has cleared the top. Default (no card) is +∞ → false.
                        let offscreen = maxY < 8
                        if offscreen != readingCardOffscreen {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                readingCardOffscreen = offscreen
                            }
                        }
                    }
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
        guard !loading, !sending else { return }
        // Refetched even when the thread already has messages: the oracle
        // answers on a background job, so a reply can land while the user is
        // away and would otherwise never appear until the app restarts. The
        // spinner is only for a thread with nothing to show yet.
        loading = thread.messages.isEmpty
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
            // Bundled suggestions when there are any — the backend's are static
            // English whatever language was asked for. All or nothing, so the
            // list is never half translated.
            thread.quickQuestions = OracleContentCatalog.prompts(
                forSlug: teller.slug,
                fromReading: draft?.readingID != nil
            )
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
                    Image(systemName: "arrow.backward")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Pigment.cream)
                        .frame(width: Cadence.tapTarget, height: Cadence.tapTarget)
                        .background(Circle().fill(Pigment.surface))
                }
                .buttonStyle(.plain)
                Spacer()
                // The cup takes over from the reading card once it scrolls away,
                // keeping the reading reachable. Only in a post-reading chat.
                if let onReturnToReading, draft?.reading != nil, readingCardOffscreen {
                    Button(action: onReturnToReading) {
                        Image("IconCup")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Pigment.accent)
                            .frame(width: Cadence.tapTarget, height: Cadence.tapTarget)
                            // The design tints this button accent-at-20%, unlike
                            // the back button's plain surface fill.
                            .background(Circle().fill(Pigment.accent.opacity(0.2)))
                    }
                    .buttonStyle(.plain)
                    .transition(.opacity.combined(with: .scale))
                }
            }
        }
        .padding(.top, 4)
        .padding(.bottom, 8)
    }

    /// A tappable summary of the reading this chat came from — returns to the
    /// full result. Shown at the top of a post-reading chat. Same shape as a
    /// History row minus the oracle badge (you are already inside that oracle's
    /// chat): the cup, the date, the topic, and the reading's own text.
    private func readingCard(_ reading: Reading, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 12) {
                cupThumb
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text(Date.now.formatted(.dateTime.month(.wide).day().year()))
                        .font(Lettering.body(10))
                        .textCase(.uppercase)
                        .foregroundStyle(Pigment.cream.opacity(0.4))

                    if let topic = draft?.topic {
                        readingTopicChip(topic)
                    }

                    Text(reading.whatISee)
                        .font(Lettering.body(12))
                        .foregroundStyle(Pigment.cream.opacity(0.8))
                        .lineSpacing(6)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 16)
            .background(RoundedRectangle(cornerRadius: 24).fill(Color(hex: 0x211836)))
            .overlay(alignment: .topTrailing) {
                // Decorative — the whole card is the button. `arrow.forward`
                // flips itself under RTL.
                Image(systemName: "arrow.forward")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Pigment.cream.opacity(0.5))
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(Color.white.opacity(0.05)))
                    .padding(12)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    /// The cup the reading was drawn from — the uploaded (or bundled Random-Cup)
    /// photo, or the bundled sample as a last resort.
    @ViewBuilder
    private var cupThumb: some View {
        if let photo = draft?.photo {
            Image(uiImage: photo).resizable().scaledToFill()
        } else {
            Image("SampleCupCard").resizable().scaledToFill()
        }
    }

    /// Topic pill in the topic's own hue, as the History card draws it.
    private func readingTopicChip(_ topic: Topic) -> some View {
        Text(topic.name)
            .font(Lettering.bodyMedium(10))
            .foregroundStyle(topic.color)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Capsule().fill(topic.color.opacity(0.15)))
            .overlay(Capsule().strokeBorder(topic.color.opacity(0.4), lineWidth: 1))
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
                            // These chips are always user-side, so the tail
                            // follows `.bottomTrailing` — which lands on the
                            // left in Arabic, where the tail must too.
                            BubbleTail(leading: layoutDirection == .rightToLeft)
                                .fill(Pigment.accentGradient)
                                .frame(width: BubbleTail.size.width, height: BubbleTail.size.height)
                                .offset(x: 3 * layoutDirection.sign)
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
                    // The glyph flies toward the far edge of the line, which is
                    // the left one in Arabic.
                    .scaleEffect(x: layoutDirection.sign)
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
                // Sending only queues the reply; the oracle answers on a job we
                // then wait on. The typing bubble covers that whole stretch.
                let response = try await repository.send(chatID: chatID, text: trimmed)
                let reply = try await repository.awaitReply(jobID: response.job.id)
                thread.messages.append(ChatMessage(isFromUser: false, text: reply))
                thread.lastUpdated = Date()
                // The reply flips the thread to unread the moment it lands, and
                // the user is looking straight at it — clear that, or the list
                // badges a message they already read.
                try? await repository.markRead(chatID: chatID)
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
