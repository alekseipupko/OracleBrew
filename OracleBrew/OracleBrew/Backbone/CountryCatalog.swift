import Foundation

struct Country: Identifiable, Hashable {
    let id: String       // ISO 3166-1 alpha-2, e.g. "AT"
    let name: String     // Localized display name, e.g. "Austria"

    /// Regional-indicator flag emoji built from the region code — "AT" → 🇦🇹.
    var flag: String {
        id.unicodeScalars.reduce(into: "") { result, scalar in
            if let indicator = UnicodeScalar(127_397 + scalar.value) {
                result.unicodeScalars.append(indicator)
            }
        }
    }
}

enum CountryCatalog {
    /// Every ISO region that has a display name, sorted alphabetically.
    /// Filters out aggregate codes (continents, "Unknown Region") — those are
    /// numeric or 3-letter and would otherwise render as broken flags.
    static let all: [Country] = {
        let locale = Locale.current
        return Locale.Region.isoRegions
            .filter { $0.identifier.count == 2 && $0.subRegions.isEmpty }
            .compactMap { region -> Country? in
                guard let name = locale.localizedString(forRegionCode: region.identifier) else { return nil }
                return Country(id: region.identifier, name: name)
            }
            .sorted { $0.name < $1.name }
    }()

    static func named(_ code: String?) -> Country? {
        guard let code else { return nil }
        return all.first { $0.id == code }
    }

    static func search(_ query: String) -> [Country] {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return all }
        return all.filter { $0.name.localizedCaseInsensitiveContains(trimmed) }
    }
}
