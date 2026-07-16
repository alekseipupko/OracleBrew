//
//  Paginated.swift
//  OracleBrew
//
//  The list envelope the API uses (page size 12): count / next / previous /
//  results. `next` being non-nil means there's another page to load.
//

import Foundation

struct Paginated<Item: Decodable>: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Item]

    var hasMore: Bool { next != nil }
}
