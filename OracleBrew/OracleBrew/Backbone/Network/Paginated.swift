import Foundation

struct Paginated<Item: Decodable>: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Item]

    var hasMore: Bool { next != nil }
}
