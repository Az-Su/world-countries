//
//  AppDelegate.swift
//  world-countries
//
//  Created by Sailau Almaz Maratuly on 12.05.2023.
//

import UIKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = Assembler.shared.createMainNavigationController()
        window.makeKeyAndVisible()
        
        if #available(iOS 13.0, *) {
            window.overrideUserInterfaceStyle = .light
        }
        
        self.window = window
        return true
    }
    
   
}
