import UIKit
import NeedleFoundation

protocol WatchNowDependency: Dependency {
}

final class WatchNowComponent: Component<WatchNowDependency> {
    func controller() -> WatchNowController {
        fatalError()
    }
}
