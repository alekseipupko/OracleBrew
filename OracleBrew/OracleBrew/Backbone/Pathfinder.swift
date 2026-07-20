import SwiftUI

@Observable
final class Pathfinder {
    var path = NavigationPath()

    func push(_ waypoint: Waypoint) { path.append(waypoint) }
    func pop() { if !path.isEmpty { path.removeLast() } }
    func popToRoot() { path = NavigationPath() }
}
