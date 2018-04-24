//
//  MainViewController.swift
//  CryptoTracking
//
//  Created by Giancarlo on 24.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, LoadingController {
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self)
        tv.backgroundColor = .lightGray
        tv.tableFooterView = UIView()
        return tv
    }()
    
    func loadData(force: Bool) {
        SessionManager.shared.start(call: CMCClient.GetSpecCurrencyTicker(tag: "ticker/ripple/")) { (result) in
            result.onSuccess { value in
                print(value.id)
                }.onError { error in
                    print("error: \(error.localizedDescription)")
            }
        }
        print("loading datasource")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.fillToSuperview(tableView)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UITableViewCell.self, for: indexPath)
        
        cell.textLabel?.text = "dsa"
        
        return cell
    }
}
