//
//  MainViewController.swift
//  CryptoTracking
//
//  Created by Giancarlo on 24.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class MainViewController: MainController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.fillToSuperview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateView()
    }
    
    private func updateView() {
        navigationItem.leftBarButtonItems = [ activityIndicatorItem]
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Add +1 for the last cell (add coin)
        return self.coinTickers.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UITableViewCell.self, for: indexPath)
        if indexPath.row != self.coinTickers.count {
            let coin = self.coinTickers[indexPath.row]
            cell.textLabel?.text = coin.name
            return cell
        }
        else {
            cell.textLabel?.text = "Add Coin"
            return cell
        }
    }
}
