import UIKit
import NeedleFoundation

protocol DashboardDependency: Dependency {
}

final class DashboardComponent: Component<DashboardDependency> {
    func controller() -> DashboardController {
        let vc = R.storyboard
            .scene_Dashboard
            .instantiateInitialViewController()!
        (vc.children[0] as? UINavigationController)?
            .pushViewController(homeComponent.controller(),
                                animated: true)
        return vc
    }
    
    var homeComponent: HomeComponent {
        HomeComponent(parent: self)
    }
}
