import Foundation

struct ProfileDTO: Codable {
    var name: String?
    var gender: String?
    var dateOfBirth: String?
    var relationshipStatus: String?
    var employmentStatus: String?
    var country: String?
    var children: String?
    var topicsOfInterest: [String]?
    var onboardingCompleted: Bool?
    var notificationsEnabled: Bool?
    var dataConsent: Bool?

    enum CodingKeys: String, CodingKey {
        case name, gender, country, children
        case dateOfBirth = "date_of_birth"
        case relationshipStatus = "relationship_status"
        case employmentStatus = "employment_status"
        case topicsOfInterest = "topics_of_interest"
        case onboardingCompleted = "onboarding_completed"
        case notificationsEnabled = "notifications_enabled"
        case dataConsent = "data_consent"
    }
}

struct ProfileRepository {
    var emissary: Emissary = .shared

    func fetch() async throws -> UserProfile {
        let dto = try await emissary.perform(EmissaryRequest(path: "profile/"), as: ProfileDTO.self)
        return ProfileMapper.domain(dto)
    }

    /// Partial update — sends only the fields the user filled in.
    @discardableResult
    func update(_ profile: UserProfile, completingOnboarding: Bool = false) async throws -> UserProfile {
        let body = ProfileMapper.patch(profile, completingOnboarding: completingOnboarding)
        let request = EmissaryRequest(path: "profile/", method: .patch, body: .json(body))
        let dto = try await emissary.perform(request, as: ProfileDTO.self)
        return ProfileMapper.domain(dto)
    }

    func deleteAccount() async throws {
        try await emissary.performVoid(EmissaryRequest(path: "account/", method: .delete))
    }
}

enum ProfileMapper {
    static func domain(_ dto: ProfileDTO) -> UserProfile {
        var profile = UserProfile()
        profile.name = dto.name ?? ""
        profile.identity = enumValue(dto.gender, Identity.self)
        profile.relationship = enumValue(dto.relationshipStatus, RelationshipStatus.self)
        profile.employment = enumValue(dto.employmentStatus, Employment.self)
        profile.children = enumValue(dto.children, ChildrenStatus.self)
        profile.countryCode = dto.country.flatMap { $0.isEmpty ? nil : $0 }
        profile.interests = Set(dto.topicsOfInterest ?? [])
        // onboarding_completed is deliberately not mapped in: whether to show
        // onboarding is a local decision (see Atrium). We report it, we don't
        // read it back.

        if let dob = dto.dateOfBirth, let (day, month, year) = parseDOB(dob) {
            profile.birthDay = day
            profile.birthMonth = month
            profile.birthYear = year
        }
        return profile
    }

    /// `completingOnboarding` is only set by the onboarding's final save —
    /// Skip deliberately leaves it unset, which is how the backend tells a
    /// finished profile from an abandoned one.
    static func patch(_ profile: UserProfile, completingOnboarding: Bool = false) -> ProfileDTO {
        ProfileDTO(
            name: profile.name.isEmpty ? nil : profile.name,
            gender: profile.identity?.rawValue,
            dateOfBirth: formatDOB(profile),
            relationshipStatus: profile.relationship?.rawValue,
            employmentStatus: profile.employment?.rawValue,
            country: profile.countryCode,
            children: profile.children?.rawValue,
            topicsOfInterest: profile.interests.isEmpty ? nil : Array(profile.interests),
            onboardingCompleted: completingOnboarding ? true : nil,
            notificationsEnabled: nil,
            dataConsent: nil
        )
    }

    // MARK: Helpers

    private static func enumValue<T: RawRepresentable>(_ raw: String?, _ type: T.Type) -> T? where T.RawValue == String {
        guard let raw, !raw.isEmpty else { return nil }
        return T(rawValue: raw)
    }

    private static func parseDOB(_ string: String) -> (day: Int, month: Int, year: Int)? {
        let parts = string.split(separator: "-")
        guard parts.count == 3,
              let year = Int(parts[0]), let month = Int(parts[1]), let day = Int(parts[2]) else { return nil }
        return (day, month, year)
    }

    private static func formatDOB(_ profile: UserProfile) -> String? {
        guard let d = profile.birthDay, let m = profile.birthMonth, let y = profile.birthYear else { return nil }
        return String(format: "%04d-%02d-%02d", y, m, d)
    }
}
