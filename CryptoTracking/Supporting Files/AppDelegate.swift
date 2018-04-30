//
//  AppDelegate.swift
//  CryptoTracking
//
//  Created by Giancarlo on 24.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit
import RealmSwift

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

        if Accessible.shared.currentUsedCurrencySymbol == "CurrencySymbolError" {
            // Set default currency
            UserDefaults.standard.set("€", forKey: Constant.Key.UserDefault.currentCurrencySymbol)
        }
        
        if Accessible.shared.currentUsedCurrencyCode == "CurrencyCodeError" {
            UserDefaults.standard.set("EUR", forKey: Constant.Key.UserDefault.currentCurrencyCode)
        }
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        mainVC.loadData(force: false)
    }
}
