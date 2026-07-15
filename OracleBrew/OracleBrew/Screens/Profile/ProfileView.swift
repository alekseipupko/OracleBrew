//
//  ProfileView.swift
//  OracleBrew
//
//  "Your Profile" — name, identity, date of birth (→ zodiac), relationship,
//  employment, country, children, interests. Reached from Settings' Personal
//  Account section: "Create an Account" when empty, "Edit an Account" once
//  saved. Save is sticky at the bottom; content scrolls under a fade.
//
//  Pushed onto Atrium's brewRouter NavigationStack — no nested NavigationStack
//  (SwiftUI renders those blank).
//

import SwiftUI

struct ProfileView: View {
    @Environment(UserProfileStore.self) private var store
    let onBack: () -> Void
    let onSaved: () -> Void

    @State private var draft = UserProfile()
    @State private var loaded = false
    @State private var openField: OpenField?
    @State private var countryQuery = ""
    @FocusState private var countrySearchFocused: Bool

    /// Only one dropdown may be open at a time — opening another closes it.
    private enum OpenField: Hashable { case day, month, year, relationship, country }

    private let fadeHeight: CGFloat = 80
    private let saveBarHeight: CGFloat = 60

    var body: some View {
        ZStack(alignment: .top) {
            Pigment.background.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                form
            }
        }
        .overlay(alignment: .bottom) { saveBar }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            guard !loaded else { return }
            draft = store.profile
            loaded = true
        }
    }

    // MARK: Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 12) {
                Button(action: onBack) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Pigment.cream)
                        .frame(width: Cadence.tapTarget, height: Cadence.tapTarget)
                        .background(Circle().fill(Pigment.surface))
                }
                .buttonStyle(.plain)

                Text("profile.title")
                    .font(Lettering.displaySemibold(28))
                    .foregroundStyle(Pigment.cream)
                Spacer(minLength: 0)
            }

            Text("profile.subtitle")
                .font(Lettering.body(12))
                .foregroundStyle(Pigment.cream.opacity(0.6))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 24)
        .padding(.top, 12)
        .padding(.bottom, 20)
    }

    // MARK: Form

    private var form: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                nameSection
                identitySection
                birthSection
                relationshipSection
                employmentSection
                countrySection
                childrenSection
                interestsSection
            }
            .padding(.horizontal, 20)
            .padding(.bottom, saveBarHeight + 40)
        }
        .scrollDismissesKeyboard(.interactively)
    }

    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            ProfileSectionLabel(title: "profile.name")
            ProfileFieldBox {
                TextField("", text: $draft.name, prompt: namePrompt)
                    .font(Lettering.display(14))
                    .foregroundStyle(Pigment.cream)
                    .tint(Pigment.accent)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
            }
        }
    }

    private var namePrompt: Text {
        Text("profile.name.placeholder").foregroundColor(Pigment.fieldMuted)
    }

    private var identitySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            ProfileSectionLabel(title: "profile.identity")
            HStack(spacing: 8) {
                ForEach(Identity.allCases) { option in
                    ProfileChip(label: option.label, isSelected: draft.identity == option) {
                        draft.identity = draft.identity == option ? nil : option
                    }
                }
            }
        }
    }

    // MARK: Date of birth → zodiac

    private var birthSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            ProfileSectionLabel(title: "profile.dob")

            HStack(alignment: .top, spacing: 10) {
                birthDropdown(.day, value: draft.birthDay.map(String.init), placeholder: "DD",
                              items: Array(1...daysInSelectedMonth)) { draft.birthDay = $0 }
                birthDropdown(.month, value: draft.birthMonth.map { Self.monthNames[$0 - 1] }, placeholder: "MM",
                              items: Array(1...12), label: { Self.monthNames[$0 - 1] }) { draft.birthMonth = $0 }
                birthDropdown(.year, value: draft.birthYear.map(String.init), placeholder: "YYYY",
                              items: Self.years) { draft.birthYear = $0 }
            }
            .zIndex(1)

            if let zodiac = draft.zodiac {
                Text("Zodiac Sign: \(zodiac.glyph) \(zodiac.name)")
                    .font(Lettering.displayMedium(14))
                    .foregroundStyle(Pigment.accent)
            } else {
                Text("profile.zodiac.empty")
                    .font(Lettering.displayMedium(14))
                    .foregroundStyle(Pigment.fieldMuted)
            }
        }
    }

    /// One of the three DOB dropdowns. `IntBox` wraps the Int so it satisfies
    /// DropdownOverlay's Identifiable requirement.
    private func birthDropdown(
        _ field: OpenField,
        value: String?,
        placeholder: String,
        items: [Int],
        label: @escaping (Int) -> String = { String($0) },
        onPick: @escaping (Int) -> Void
    ) -> some View {
        let boxes = items.map(IntBox.init)
        let isOpen = openField == field
        return VStack(spacing: 4) {
            Button { toggle(field) } label: {
                ProfileFieldBox(radius: 10) {
                    HStack(spacing: 0) {
                        Text(value ?? placeholder)
                            .font(Lettering.display(14))
                            .foregroundStyle(value == nil ? Pigment.fieldMuted : Pigment.cream)
                            .lineLimit(1)
                        Spacer(minLength: 4)
                        DropdownChevron(isOpen: isOpen)
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isOpen {
                DropdownOverlay(
                    items: boxes,
                    isSelected: { box in value == label(box.value) },
                    onPick: { box in
                        onPick(box.value)
                        clampDayIfNeeded()
                        openField = nil
                    },
                    label: { box in
                        Text(label(box.value))
                            .font(Lettering.display(14))
                            .foregroundStyle(Pigment.cream)
                    }
                )
            }
        }
    }

    private struct IntBox: Identifiable { let value: Int; var id: Int { value } }

    private var relationshipSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            ProfileSectionLabel(title: "profile.relationship")
            VStack(spacing: 4) {
                Button { toggle(.relationship) } label: {
                    ProfileFieldBox {
                        HStack(spacing: 0) {
                            Text(draft.relationship?.label ?? String(localized: "profile.relationship.placeholder"))
                                .font(Lettering.display(15))
                                .foregroundStyle(draft.relationship == nil ? Pigment.fieldMuted : Pigment.cream)
                            Spacer()
                            DropdownChevron(isOpen: openField == .relationship)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                if openField == .relationship {
                    DropdownOverlay(
                        items: RelationshipStatus.allCases,
                        isSelected: { draft.relationship == $0 },
                        onPick: { draft.relationship = $0; openField = nil },
                        label: { option in
                            Text(option.label)
                                .font(Lettering.display(14))
                                .foregroundStyle(draft.relationship == option ? Pigment.accent : Pigment.cream)
                        }
                    )
                }
            }
        }
        .zIndex(openField == .relationship ? 1 : 0)
    }

    private var employmentSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            ProfileSectionLabel(title: "profile.employment")
            // 5 options: 3 across, then 2 centred — matching the design. The
            // second row's chips are sized off the first row's column width so
            // both rows stay aligned on every diagonal.
            GeometryReader { geo in
                let columnWidth = (geo.size.width - 16) / 3
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        ForEach(Employment.allCases.prefix(3)) { option in
                            chip(option).frame(width: columnWidth)
                        }
                    }
                    HStack(spacing: 8) {
                        ForEach(Employment.allCases.suffix(2)) { option in
                            chip(option).frame(width: columnWidth)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .frame(height: Cadence.tapTarget * 2 + 8)
        }
    }

    private func chip(_ option: Employment) -> some View {
        ProfileChip(label: option.label, isSelected: draft.employment == option) {
            draft.employment = draft.employment == option ? nil : option
        }
    }

    private var countrySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            ProfileSectionLabel(title: "profile.country")
            VStack(spacing: 4) {
                Button { toggle(.country) } label: {
                    ProfileFieldBox {
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(Pigment.fieldMuted)
                            if openField == .country {
                                TextField("", text: $countryQuery, prompt: countryPrompt)
                                    .font(Lettering.display(15))
                                    .foregroundStyle(Pigment.cream)
                                    .tint(Pigment.accent)
                                    .autocorrectionDisabled()
                                    .focused($countrySearchFocused)
                            } else if let country = CountryCatalog.named(draft.countryCode) {
                                Text("\(country.flag) \(country.name)")
                                    .font(Lettering.display(15))
                                    .foregroundStyle(Pigment.cream)
                                    .lineLimit(1)
                            } else {
                                Text("profile.country.placeholder")
                                    .font(Lettering.display(15))
                                    .foregroundStyle(Pigment.fieldMuted)
                            }
                            Spacer(minLength: 0)
                            DropdownChevron(isOpen: openField == .country)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                if openField == .country {
                    DropdownOverlay(
                        items: CountryCatalog.search(countryQuery),
                        isSelected: { draft.countryCode == $0.id },
                        onPick: { country in
                            draft.countryCode = country.id
                            countryQuery = ""
                            openField = nil
                        },
                        label: { country in
                            Text("\(country.flag) \(country.name)")
                                .font(Lettering.display(14))
                                .foregroundStyle(draft.countryCode == country.id ? Pigment.accent : Pigment.cream)
                                .lineLimit(1)
                        }
                    )
                }
            }
        }
        .zIndex(openField == .country ? 1 : 0)
    }

    private var countryPrompt: Text {
        Text("profile.country.placeholder").foregroundColor(Pigment.fieldMuted)
    }

    private var childrenSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            ProfileSectionLabel(title: "profile.children")
            HStack(spacing: 8) {
                ForEach(ChildrenStatus.allCases) { option in
                    ProfileChip(label: option.label, isSelected: draft.children == option) {
                        draft.children = draft.children == option ? nil : option
                    }
                }
            }
        }
    }

    private var interestsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            ProfileSectionLabel(title: "profile.interests")
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                ForEach(InterestCatalog.all) { interest in
                    InterestChip(interest: interest, isSelected: draft.interests.contains(interest.id)) {
                        if draft.interests.contains(interest.id) {
                            draft.interests.remove(interest.id)
                        } else {
                            draft.interests.insert(interest.id)
                        }
                    }
                }
            }
        }
    }

    // MARK: Save

    private var saveBar: some View {
        Button {
            store.save(draft)
            onSaved()
        } label: {
            Text("profile.save")
                .font(Lettering.displayMedium(18))
                .foregroundStyle(Pigment.cream)
                .frame(maxWidth: .infinity)
                .frame(height: saveBarHeight)
                .background(Capsule().fill(Pigment.accentGradient))
                .opacity(canSave ? 1 : 0.4)
                .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .disabled(!canSave)
        .padding(.horizontal, 20)
        .padding(.top, fadeHeight)
        .background(
            // Fades the form out above the button, then stays solid behind and
            // below it — the solid part runs past the safe area, otherwise
            // content scrolling under the home indicator shows through.
            LinearGradient(
                stops: [
                    .init(color: Pigment.background.opacity(0), location: 0),
                    .init(color: Pigment.background, location: fadeHeight / (fadeHeight + saveBarHeight)),
                    .init(color: Pigment.background, location: 1),
                ],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea(edges: .bottom)
            .allowsHitTesting(false)
        )
    }

    /// The name is what the rest of the app reads, so it gates Save.
    private var canSave: Bool {
        !draft.name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    // MARK: Helpers

    private func toggle(_ field: OpenField) {
        openField = openField == field ? nil : field
        // The country list is long, so its search field takes focus as soon as
        // the dropdown opens rather than needing a second tap.
        countrySearchFocused = openField == .country
        if openField != .country { countryQuery = "" }
    }

    /// Feb 30 shouldn't survive a month change.
    private func clampDayIfNeeded() {
        if let day = draft.birthDay, day > daysInSelectedMonth {
            draft.birthDay = daysInSelectedMonth
        }
    }

    private var daysInSelectedMonth: Int {
        guard let month = draft.birthMonth else { return 31 }
        var components = DateComponents()
        components.year = draft.birthYear ?? 2000
        components.month = month
        let calendar = Calendar(identifier: .gregorian)
        guard let date = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: date) else { return 31 }
        return range.count
    }

    /// A bare Calendar(identifier:) carries no locale, and monthSymbols then
    /// yields "M01"…"M12" instead of month names — so set the locale.
    private static let monthNames: [String] = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = .current
        return calendar.monthSymbols
    }()
    private static let years: [Int] = {
        let current = Calendar.current.component(.year, from: Date())
        return Array((current - 100)...(current - 13)).reversed()
    }()
}
