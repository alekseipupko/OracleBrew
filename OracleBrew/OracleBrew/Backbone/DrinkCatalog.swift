import SwiftUI

struct Drink: Identifiable, Equatable {
    let id: String
    let name: LocalizedStringKey
    let blurb: LocalizedStringKey
    let art: String
    let gradient: [Color]
    let isRandom: Bool
    /// Set for drinks coming from the API; nil for the bundled mock drinks,
    /// which draw from `art` instead.
    var imageURL: String? = nil

    static func == (lhs: Drink, rhs: Drink) -> Bool { lhs.id == rhs.id }
}

enum DrinkCatalog {
    /// The "Random Cup" entry — a client-side path (the app supplies the cup),
    /// so it's prepended to whatever real drinks the catalog holds.
    static let randomCup = Drink(id: "random", name: "drink.random.name", blurb: "drink.random.blurb",
                                 art: "DrinkRandom", gradient: [Color(hex: 0x241649), Color(hex: 0x0E062C)], isRandom: true)

    static let all: [Drink] = [
        randomCup,
        Drink(id: "turkish", name: "drink.turkish.name", blurb: "drink.turkish.blurb",
              art: "DrinkTurkish", gradient: [Color(hex: 0x351B27), Color(hex: 0x1C111A)], isRandom: false),
        Drink(id: "espresso", name: "drink.espresso.name", blurb: "drink.espresso.blurb",
              art: "DrinkEspresso", gradient: [Color(hex: 0x271C41), Color(hex: 0x161126)], isRandom: false),
        Drink(id: "herbal", name: "drink.herbal.name", blurb: "drink.herbal.blurb",
              art: "DrinkHerbal", gradient: [Color(hex: 0x4C3C22), Color(hex: 0x201A13)], isRandom: false),
        Drink(id: "tea", name: "drink.tea.name", blurb: "drink.tea.blurb",
              art: "DrinkTea", gradient: [Color(hex: 0x1E2C48), Color(hex: 0x0C1730)], isRandom: false),
        Drink(id: "matcha", name: "drink.matcha.name", blurb: "drink.matcha.blurb",
              art: "DrinkMatcha", gradient: [Color(hex: 0x2B3929), Color(hex: 0x0D1B0A)], isRandom: false),
        Drink(id: "chocolate", name: "drink.chocolate.name", blurb: "drink.chocolate.blurb",
              art: "DrinkChocolate", gradient: [Color(hex: 0x40222B), Color(hex: 0x21141B)], isRandom: false),
        Drink(id: "wine", name: "drink.wine.name", blurb: "drink.wine.blurb",
              art: "DrinkWine", gradient: [Color(hex: 0x4F2039), Color(hex: 0x260B1A)], isRandom: false)
    ]

    /// A random non-Random drink, for the "Random Cup" path.
    static func randomPick() -> Drink {
        all.filter { !$0.isRandom }.randomElement() ?? all[1]
    }
}
