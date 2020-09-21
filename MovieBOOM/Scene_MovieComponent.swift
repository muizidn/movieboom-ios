import UIKit
import NeedleFoundation

protocol MovieDependency: Dependency {
    var hello: String { get }
}

final class MovieComponent: Component<MovieDependency> {
    
    func controller(id: Int) -> MovieController {
        let vc = R.storyboard
            .scene_Movie
            .instantiateInitialViewController()!
        
        print("just want to say",dependency.hello)
        
        vc.currentId = id
        vc.route = self
        return vc
    }
}

protocol MovieComponentRoute {
}

extension MovieComponent: MovieComponentRoute {
}
