import UIKit
import NeedleFoundation

protocol LoginDependency: Dependency {
}

final class LoginComponent: Component<LoginDependency> {
    func controller() -> LoginController {
        return R.storyboard
            .scene_Login
            .instantiateInitialViewController()!
    }
}
