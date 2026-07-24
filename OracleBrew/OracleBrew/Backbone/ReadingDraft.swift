import SwiftUI

@Observable
final class ReadingDraft {
    var drink: Drink?
    /// True when the user picked "Random Cup" — `drink` still holds a real,
    /// concrete drink (randomly assigned at selection time) so downstream
    /// screens never display "Random" as if it were a drink name.
    var isRandomPath = false
    var teller: FortuneTeller?

    // Intention
    var horizon: TimeHorizon = .month
    var topic: Topic?
    var question: String = ""

    // Photo of the cup — gallery, camera, or a bundled cup for the Random path.
    // The Random path picks one of the drink's bundled cup photos and stores it
    // here too, so both paths create the reading the same way: by uploading this
    // image. There is no separate backend cup id any more.
    var photo: UIImage?

    /// Set once this reading is recorded into ReadingHistoryStore, so re-appearing
    /// on Reading Result (e.g. after a chat) doesn't record a duplicate entry.
    var historySessionID: UUID?

    /// The reading the API produced, filled in by the Loading step and shown on
    /// the Result screen. `readingID` is the server id, used to start a chat.
    var reading: Reading?
    var readingID: Int?
    /// Whether a chat with this reading's oracle already exists — drives the
    /// result CTA ("Return to chat" vs "Ask Your Oracle"). True for a History
    /// replay whose card showed the chat icon.
    var readingHasChat = false
}
