//
//  AppDelegate.swift
//  YouTube2
//
//  Created by Smart Castle M1A2009 on 07.01.2024.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let vc = MainTabBarController()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        
        
        window?.rootViewController = navController
        return true
    }


}

