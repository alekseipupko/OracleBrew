//
//  Waypoint.swift
//  OracleBrew
//
//  Push destinations, driven by Pathfinder. Grows as flows land.
//

import Foundation

enum Waypoint: Hashable {
    case settings
    case brewReading   // Drink Selection → … → Reading Result
    case oracleChat    // direct chat entry
}
