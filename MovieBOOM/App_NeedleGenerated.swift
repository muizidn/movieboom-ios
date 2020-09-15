

import NeedleFoundation
import UIKit

let needleDependenciesHash : String? = nil

// MARK: - Registration

public func registerProviderFactories() {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->DashboardComponent") { component in
        return DashboardDependencyc777540156f3b146f831Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->LoginComponent") { component in
        return LoginDependency006c7d880fec28863ecaProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent") { component in
        return EmptyDependencyProvider(component: component)
    }
    
}

// MARK: - Providers

private class DashboardDependencyc777540156f3b146f831BaseProvider: DashboardDependency {


    init() {

    }
}
/// ^->RootComponent->DashboardComponent
private class DashboardDependencyc777540156f3b146f831Provider: DashboardDependencyc777540156f3b146f831BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
private class LoginDependency006c7d880fec28863ecaBaseProvider: LoginDependency {


    init() {

    }
}
/// ^->RootComponent->LoginComponent
private class LoginDependency006c7d880fec28863ecaProvider: LoginDependency006c7d880fec28863ecaBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
