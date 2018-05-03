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
    
    lazy var tabbarVC: TabbarCollectionViewController = {
        return TabbarCollectionViewController()
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Accessible.shared.getCurrencyValueConverted(target: "EUR") { (convertedValue) in
            Accessible.Currency.convertedValue = convertedValue
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        window?.rootViewController = tabbarVC
        
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
        tabbarVC.mainVC.loadData(force: true)
//        mainVC.loadData(force: false)
    }
}
