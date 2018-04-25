//
//  BaseViewController.swift
//  CryptoTracking
//
//  Created by Giancarlo on 25.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, ChangeableTheme {
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        av.isHidden = true
        av.hidesWhenStopped = true
        av.startAnimating()
        return av
    }()
    
    lazy var activityIndicatorItem: UIBarButtonItem = {
        let btn = UIBarButtonItem(customView: self.activityIndicator)
        return btn
    }()
    
    func activityIndicatorAdded() -> Bool {
        if !activityIndicator.isHidden {
            navigationItem.leftBarButtonItems = [ activityIndicatorItem ]
            return true
        }
        else {
            // Do stuff in else condition that will happen after indicator has been loaded
            return false
        }
    }
    
    func changeTheme() { }

    var model: Theme?
    
    func applyTheme(_ theme: Theme) {
        self.model = theme
        changeTheme()
        print("model applied")
    }
}

