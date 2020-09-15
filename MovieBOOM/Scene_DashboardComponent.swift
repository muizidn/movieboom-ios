import UIKit
import NeedleFoundation

protocol DashboardDependency: Dependency {
}

final class DashboardComponent: Component<DashboardDependency> {
    func controller() -> DashboardController {
        return R.storyboard
            .scene_Dashboard
            .instantiateInitialViewController()!
    }
}
