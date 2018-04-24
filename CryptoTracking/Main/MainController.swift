//
//  MainController.swift
//  CryptoTracking
//
//  Created by Giancarlo on 24.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class MainController: UIViewController, LoadingController {
    
    var coinTickers = [CoinTicker]()
    
    func loadData(force: Bool) {
        SessionManager.shared.start(call: CMCClient.GetSpecCurrencyTicker(tag: "ticker/ripple/")) { (result) in
            result.onSuccess { value in
                self.coinTickers = value.items
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                self.activityIndicator.stopAnimating()
                }.onError { error in
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    print("error: \(error.localizedDescription)")
            }
        }
    }
    
    
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
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self)
        tv.backgroundColor = .lightGray
        tv.tableFooterView = UIView()
        return tv
    }()
}


