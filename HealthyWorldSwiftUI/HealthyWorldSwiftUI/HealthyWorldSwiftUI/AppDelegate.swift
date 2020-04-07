//
//  AppDelegate.swift
//  HealthyWorldSwiftUI
//
//  Created by Aleksa Simic on 17.01.20.
//  Copyright © 2020 Aleksa Simic. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupColors()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func setupColors() {
        let primaryColor = UIColor.init(red: 39/255, green: 169/255, blue: 67/255, alpha: 1.0)
        UITabBar.appearance().backgroundColor = UIColor.init(red: 201/255, green: 255/255, blue: 161/255, alpha: 1.0)
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = primaryColor
        UIToolbar.appearance().barTintColor = .blue
        UIToolbar.appearance().tintColor = primaryColor
        UITableView.appearance().separatorColor = .clear
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: primaryColor]
        UINavigationBar.appearance().titleTextAttributes = titleTextAttributes
    }
}

