import SwiftUI

extension View {
    func waypointDestinations(_ router: Pathfinder) -> some View {
        navigationDestination(for: Waypoint.self) { waypoint in
            switch waypoint {
            case .settings:
                SettingsView(onBack: router.pop) { router.push(.profile) }
            case .profile:
                ProfileView(onBack: router.pop, onSaved: router.pop)
            }
        }
    }
}
