//
//  ThemeManager.swift
//  CryptoTracking
//
//  Created by Giancarlo on 24.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

protocol ChangeableTheme {
    associatedtype T
    
    var model: T? { get set }
    func applyTheme (_: T)
    func changeTheme()
}

enum Theme: Int {
    
    case standard, dark
    
    var title: String {
        switch self {
        case .standard:
            return "Standard Mode"
        case .dark:
            return "Dark Mode"
        }
    }
    
    var mainColor: UIColor {
        switch self {
        case .standard:
            return UIColor.CryptoTracking.standardMain
        case .dark:
            return UIColor.CryptoTracking.darkMain
        }
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .standard:
            return .default
        case .dark:
            return .black
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .standard:
            return UIColor.CryptoTracking.standardBackground
        case .dark:
            return UIColor.CryptoTracking.darkBackground
        }
    }
    
    var secondaryColor: UIColor {
        switch self {
        case .standard:
            return UIColor.CryptoTracking.standardSecondary
        case .dark:
            return UIColor.CryptoTracking.darkSecondary
        }
    }
    
    var titleTextColor: UIColor {
        switch self {
        case .standard:
            return UIColor.CryptoTracking.standardTitle
        case .dark:
            return UIColor.CryptoTracking.darkTitle
        }
    }
    
    var subtitleTextColor: UIColor {
        switch self {
        case .standard:
            return UIColor.CryptoTracking.standardSubtitle
        case .dark:
            return UIColor.CryptoTracking.darkSubtitle
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .standard:
            return UIColor.CryptoTracking.standardTint
        case .dark:
            return UIColor.CryptoTracking.darkTint
        }
    }
    
    static let all: [Theme] = [ .standard, .dark ]
}

class ThemeManager {
    
    static func updateColors() {
        if let currentview = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController?.view {
            if let superview = currentview.superview {
                currentview.removeFromSuperview()
                superview.addSubview(currentview)
            }
        }
    }
    
    static func currentTheme() -> Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: Constant.Key.UserDefault.selectedTheme) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .standard
        }
    }
    
    static func applyTheme(_ theme: Theme) {
        
        // Save the theme by storing its rawValue in UserDefault
        UserDefaults.standard.setValue(theme.rawValue, forKey: Constant.Key.UserDefault.selectedTheme)
        UserDefaults.standard.synchronize()
        
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.secondaryColor
        
        UINavigationBar.appearance().barTintColor = theme.mainColor
        UINavigationBar.appearance().barStyle = theme.barStyle
        UINavigationBar.appearance().backgroundColor = theme.backgroundColor
        UINavigationBar.appearance().tintColor = theme.tintColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: UIFont.cryptoRegularLarge]
        UINavigationBar.appearance().isTranslucent = false
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont.cryptoRegularLarge], for: .normal)
        
        UILabel.appearance().textColor = theme.tintColor
        
        UITableView.appearance().backgroundColor = theme.backgroundColor
        
        updateColors()
    }
}
