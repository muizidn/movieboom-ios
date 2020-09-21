import UIKit
import NeedleFoundation

protocol HomeDependency: Dependency {
}

final class HomeComponent: Component<HomeDependency> {
    func controller() -> HomeController {
        let vc = R.storyboard
            .scene_Home
            .instantiateInitialViewController()!
        vc.route = self
        return vc
    }
}

protocol HomeComponentRoute {
    var movieComponent: MovieComponent { get }
}

extension HomeComponent: HomeComponentRoute {
    var movieComponent: MovieComponent {
        return MovieComponent(parent: self)
    }
}
