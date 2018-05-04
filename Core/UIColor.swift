//
//  UIColor.swift
//  CryptoTracking
//
//  Created by Giancarlo on 25.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

extension UIColor {
    struct CryptoTracking {
        
        static let main = UIColor(red:0.32, green:0.36, blue:0.49, alpha:1.0)
        
        // Standard Mode Colors
        static let standardMain = UIColor.white
        static let standardSecondary = UIColor.lightGray
        static let standardBackground = UIColor.white
        static let standardTitle = UIColor.black
        static let standardSubtitle = UIColor.black
        static let standardTint = UIColor.black

        
        // Dark Mode Colors
        static let darkMain = UIColor(red:0.20, green:0.21, blue:0.31, alpha:1.0)
        static let darkSecondary = #colorLiteral(red: 0.4633864961, green: 0.4633864961, blue: 0.4633864961, alpha: 1)
        static let darkBackground = #colorLiteral(red: 0.9044284326, green: 0.9044284326, blue: 0.9044284326, alpha: 1)
        static let darkTitle = UIColor.black
        static let darkSubtitle = UIColor.black
        static let darkTint = UIColor.white
    }
}
