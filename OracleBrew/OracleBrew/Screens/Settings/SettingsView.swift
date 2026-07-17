//
//  SettingsView.swift
//  OracleBrew
//
//  General (Pro Plan, Restore Purchases) / Legal & Support (Privacy Policy,
//  Terms Of Use, Support) / Permissions (Camera, Notifications, Data Consent)
//  / Personal account (Create an account — no onboarding/auth yet in v1.0,
//  so this is the only account state that exists). Reached from the Brew
//  tab's gear icon.
//
//  Pushed onto Atrium's brewRouter NavigationStack — it registers its own
//  navigationDestination on that SAME stack rather than nesting a second
//  NavigationStack, which SwiftUI renders blank.
//

import AVFoundation
import SwiftUI
import UserNotifications

enum SettingsDestination: Hashable {
    case privacy, terms
}

struct SettingsView: View {
    @Environment(Pathfinder.self) private var router
    @Environment(UserProfileStore.self) private var profileStore
    @Environment(SessionGate.self) private var session
    let onBack: () -> Void
    let onOpenProfile: () -> Void

    @State private var cameraAuthorized = false
    @State private var notificationsAuthorized = false
    @AppStorage("settings.dataConsent") private var dataConsent = false
    @State private var showComingSoon = false
    @State private var showDeleteConfirm = false

    var body: some View {
        ZStack(alignment: .top) {
            Pigment.background.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        generalSection
                        legalSection
                        permissionsSection
                        accountSection
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 40)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 4)
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(for: SettingsDestination.self, destination: destination)
        .onAppear(perform: refreshPermissionStatus)
        .alert("settings.coming_soon.title", isPresented: $showComingSoon) {
            Button("common.ok", role: .cancel) {}
        } message: {
            Text("settings.coming_soon.message")
        }
        .alert("settings.delete_account.title", isPresented: $showDeleteConfirm) {
            Button("settings.delete_account.confirm", role: .destructive) {
                Task {
                    await profileStore.deleteAccount()
                    // The old token died with the account — mint a fresh guest
                    // so the app keeps working.
                    await session.recoverFromUnauthorized()
                }
            }
            Button("common.cancel", role: .cancel) {}
        } message: {
            Text("settings.delete_account.message")
        }
    }

    @ViewBuilder
    private func destination(_ dest: SettingsDestination) -> some View {
        switch dest {
        case .privacy:
            LegalTextView(title: "settings.privacy_policy", text: LegalCopy.privacyPolicy, onBack: router.pop)
        case .terms:
            LegalTextView(title: "settings.terms", text: LegalCopy.termsOfUse, onBack: router.pop)
        }
    }

    // MARK: Sections

    private var generalSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SettingsSectionLabel(title: "settings.section.general")
            SettingsCard {
                SettingsRow(icon: "IconCrown", title: "settings.pro_plan", tint: Pigment.gold, iconTint: Pigment.gold) {
                    showComingSoon = true
                }
                SettingsDivider()
                SettingsRow(icon: "IconCart", title: "settings.restore") {
                    showComingSoon = true
                }
            }
        }
    }

    private var legalSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SettingsSectionLabel(title: "settings.section.legal")
            SettingsCard {
                SettingsRow(icon: "IconPrivacy", title: "settings.privacy_policy") {
                    router.path.append(SettingsDestination.privacy)
                }
                SettingsDivider()
                SettingsRow(icon: "IconTerms", title: "settings.terms") {
                    router.path.append(SettingsDestination.terms)
                }
                SettingsDivider()
                SettingsRow(icon: "IconSupport", title: "settings.support") {
                    if let url = URL(string: "mailto:support@oraclebrew.app") {
                        UIApplication.shared.open(url)
                    }
                }
            }
        }
    }

    private var permissionsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SettingsSectionLabel(title: "settings.section.permissions")
            SettingsCard {
                SettingsToggleRow(icon: "IconCamera", title: "settings.camera_access",
                                   isOn: $cameraAuthorized, interactive: false, onTap: openSystemSettings)
                SettingsDivider()
                SettingsToggleRow(icon: "IconBell", title: "settings.notifications",
                                   isOn: $notificationsAuthorized, interactive: false, onTap: openSystemSettings)
                SettingsDivider()
                SettingsToggleRow(icon: "IconShield", title: "settings.data_consent", isOn: $dataConsent)
            }
        }
    }

    /// No profile yet → a single "Create an Account" row. Once saved, it turns
    /// into "Edit an Account" + "Delete Account" (per the design's notes).
    private var accountSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SettingsSectionLabel(title: "settings.section.account")
            SettingsCard {
                if profileStore.profile.isCreated {
                    SettingsRow(icon: "IconEdit", title: "settings.edit_account", action: onOpenProfile)
                    SettingsDivider()
                    SettingsRow(icon: "IconUserMinus", title: "settings.delete_account",
                                tint: Pigment.danger, iconTint: Pigment.danger, weight: .semibold) {
                        showDeleteConfirm = true
                    }
                } else {
                    // The design only draws the created state, so there's no
                    // slice for this row — it opens the same profile form as
                    // "Edit an Account", so it borrows that icon.
                    SettingsRow(icon: "IconEdit", title: "settings.create_account",
                                action: onOpenProfile)
                }
            }
        }
    }

    // MARK: Permissions

    private func refreshPermissionStatus() {
        cameraAuthorized = AVCaptureDevice.authorizationStatus(for: .video) == .authorized
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            Task { @MainActor in
                notificationsAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }

    private func openSystemSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    // MARK: Header

    private var header: some View {
        ZStack {
            Text("settings.title")
                .font(Lettering.displayMedium(24))
                .foregroundStyle(Pigment.cream)
            HStack {
                Button(action: onBack) {
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
    }
}
