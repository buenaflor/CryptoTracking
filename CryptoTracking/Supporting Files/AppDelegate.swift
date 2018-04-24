//
//  AppDelegate.swift
//  CryptoTracking
//
//  Created by Giancarlo on 24.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var mainVC: MainViewController = {
        return MainViewController()
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let navController = UINavigationController(rootViewController: mainVC)
        window?.rootViewController = navController
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        mainVC.loadData(force: false)
    }
}

extension UIViewController {
    
}

