//
//  AppDelegate.swift
//  Custom photo albums
//
//  Created by Aleksandr Tsebrii on 4/25/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UINavigationBar.appearance().barTintColor = UIColor.Design.navigationBar
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.white]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: AlbumsController())
        window?.makeKeyAndVisible()
        
        return true
    }

}

