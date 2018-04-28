//
//  Shared.swift
//  CryptoTracking
//
//  Created by Giancarlo on 24.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

//  MARK: - Data Loading

protocol LoadingController {
    
    /// Called, when the data should load
    func loadData(force: Bool)
}

/// Class for shared activity throughout the app
class Accessible {
    
    var currentUsedCurrencySymbol: String {
        return UserDefaults.standard.string(forKey: Constant.Key.UserDefault.currentCurrencySymbol) ?? "CurrencySymbolError"
    }
    
    var currentUsedCurrencyCode: String {
        return UserDefaults.standard.string(forKey: Constant.Key.UserDefault.currentCurrencyCode) ?? "CurrencyCodeError"
    }
    
    func getCurrencyValueConverted(target: String, completion: @escaping (Double) -> Void) {
        CurrencyManager.shared.convertCurrency(from: currentUsedCurrencyCode, to: target) { (results) in
            print(self.currentUsedCurrencyCode)
            completion(results.val)
        }
    }
    
    func setCurrency(code: String) {
        CurrencyManager.shared.currencyList { (currencies) in
            if let currencyOffSet = currencies.index(where: {$0.value.code == code}) {
                let symbol = currencies[currencyOffSet].value.symbolNative
                let code = currencies[currencyOffSet].value.code
                UserDefaults.standard.set(symbol, forKey: Constant.Key.UserDefault.currentCurrencySymbol)
                UserDefaults.standard.set(code, forKey: Constant.Key.UserDefault.currentCurrencyCode)
            }
        }
    }
}

extension Accessible {
    static let shared = Accessible()
}

// MARK: - Custom Fonts

extension UIFont {
    public class var cryptoBlack: UIFont {
        return UIFont(name: "DINPro-Black", size: 15.0)!// ?? UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightBlack)
    }
    public class var cryptoBlackLarge: UIFont {
        return UIFont(name: "DINPro-Black", size: 20.0)!// ?? UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightBlack)
    }
    public class var cryptoBold: UIFont {
        return UIFont(name: "DINPro-Bold", size: 15.0)!// ?? UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightBold)
    }
    public class var cryptoBoldLarge: UIFont {
        return UIFont(name: "DINPro-Bold", size: 20.0)!// ?? UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightBold)
    }
    public class var cryptoLight: UIFont {
        return UIFont(name: "DINPro-Light", size: 15.0)!// ?? UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightLight)
    }
    public class var cryptoMedium: UIFont {
        return UIFont(name: "DINPro-Medium", size: 15.0)!// ?? UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightMedium)
    }
    public class var cryptoRegular: UIFont {
        return UIFont(name: "DINPro-Regular", size: 15.0)! //?? UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightRegular)
    }
    public class var cryptoRegularMedium: UIFont {
        return UIFont(name: "DINPro-Regular", size: 17.5)! //?? UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightRegular)
    }
    public class var cryptoRegularLarge: UIFont {
        return UIFont(name: "DINPro-Regular", size: 20.0)!
    }
}
