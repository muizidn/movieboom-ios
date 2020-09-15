//
//  AppDelegate.swift
//  MovieBOOM
//
//  Created by Muis on 22/08/20.
//  Copyright © 2020 Muis. All rights reserved.
//

import UIKit
import NeedleFoundation
import Keys

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private lazy var rootComponent: RootComponent = {
        // Needle
        // must before rootcomponent
        registerProviderFactories()
        
        let c = RootComponent()
        return c
    }()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        window.rootViewController = rootComponent.controller()
        
        window.makeKeyAndVisible()
        
        self.window = window
        
        TMDBConfiguration.shared.updateFromApi()
        
        return true
    }
    
}

