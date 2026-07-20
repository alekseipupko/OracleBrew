import Foundation

enum Features {
    /// v1.0 is free: there's nothing to buy and nothing to restore, so the
    /// Pro Plan and Restore Purchases rows stay out of Settings until the
    /// purchase flow is real.
    static let paywall = false

    /// The data-consent toggle is hidden with it — this build asks for no
    /// consent it would act on.
    static let dataConsent = false

    /// Nothing sends push yet, so Settings doesn't offer a notifications
    /// permission the app would never use.
    static let notifications = false
}
