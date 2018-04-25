//
//  CryptoSearchViewController.swift
//  CryptoTracking
//
//  Created by Giancarlo on 25.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class CryptoSearchViewController: BaseViewController, LoadingController {
    
    func loadData(force: Bool) {
        SessionManager.shared.start(call: CMCClient.GetSpecCurrencyTicker(tag: "ticker/bitcoin")) { (result) in
            result.onSuccess { value in
                print("success bro")
                }.onError { error in
                    print(error.localizedDescription)
            }
        }
    }
    
    func changed() {}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // temporary until thememanger is fixed completely
        view.backgroundColor = .white
    }
}
