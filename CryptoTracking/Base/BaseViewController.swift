//
//  BaseViewController.swift
//  CryptoTracking
//
//  Created by Giancarlo on 25.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, ChangeableTheme {
    
    func changeTheme() { }

    var model: Theme?
    
    func applyTheme(_ theme: Theme) {
        self.model = theme
        changeTheme()
        print("model applied")
    }
}

