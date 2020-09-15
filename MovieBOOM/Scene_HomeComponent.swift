import UIKit
import NeedleFoundation

protocol HomeDependency: Dependency {
}

final class HomeComponent: Component<HomeDependency> {
    func controller() -> HomeController {
        return R.storyboard
            .scene_Home
            .instantiateInitialViewController()!
    }
}
