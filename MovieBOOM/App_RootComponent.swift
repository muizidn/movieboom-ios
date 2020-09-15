import UIKit
import NeedleFoundation

/// Root Component, initialize most dependencies
///
/// If isFirst launch Login else Dashboard
///
final class RootComponent: BootstrapComponent {
    
    func controller() -> UIViewController {
        if AppState.get(Environment.isFirstTime)
            || AppState.get(Environment.session).isEmpty {
            AppState.set(Environment.isFirstTime, value: false)
            return loginComponent.controller()
        } else {
            return dashboardComponent.controller()
        }
    }
    
    var loginComponent: LoginComponent {
        LoginComponent(parent: self)
    }
    
    var dashboardComponent: DashboardComponent {
        DashboardComponent(parent: self)
    }
}
