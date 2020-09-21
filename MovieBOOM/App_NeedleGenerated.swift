

import NeedleFoundation
import UIKit

let needleDependenciesHash : String? = nil

// MARK: - Registration

public func registerProviderFactories() {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->DashboardComponent") { component in
        return DashboardDependencyc777540156f3b146f831Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->DashboardComponent->HomeComponent->MovieComponent") { component in
        return MovieDependencydceb6fedb074173d2b2aProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->DashboardComponent->HomeComponent") { component in
        return HomeDependencyf96ec618679f62babc45Provider(component: component)
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
private class MovieDependencydceb6fedb074173d2b2aBaseProvider: MovieDependency {
    var hello: String {
        return rootComponent.hello
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->DashboardComponent->HomeComponent->MovieComponent
private class MovieDependencydceb6fedb074173d2b2aProvider: MovieDependencydceb6fedb074173d2b2aBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(rootComponent: component.parent.parent.parent as! RootComponent)
    }
}
private class HomeDependencyf96ec618679f62babc45BaseProvider: HomeDependency {


    init() {

    }
}
/// ^->RootComponent->DashboardComponent->HomeComponent
private class HomeDependencyf96ec618679f62babc45Provider: HomeDependencyf96ec618679f62babc45BaseProvider {
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
