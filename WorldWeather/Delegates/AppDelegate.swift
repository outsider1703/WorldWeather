//
//  AppDelegate.swift
//  WorldWeather
//
//  Created by Macbook on 20.10.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import UIKit
import SnapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let flag = UserDefaults.standard.object(forKey: "chekFlag") as? String
        
        if flag == nil {
            UserDefaults.standard.setValue("flag", forKey: "chekFlag")
            CoreDataManager.shared.getDataFromFile()
        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
}

