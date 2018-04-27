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
        
        window?.rootViewController = mainVC.wrapped()
        
        let currentTheme = ThemeManager.currentTheme()
        ThemeManager.applyTheme(currentTheme)

        if Accessible.shared.currentUsedCurrency == "CurrencyError" {
            // Set default currency
            UserDefaults.standard.set("€", forKey: Constant.Key.UserDefault.currentCurrency)
        }
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        mainVC.loadData(force: false)
    }
}
