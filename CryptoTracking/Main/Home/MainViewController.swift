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
        
        if !activityIndicatorAdded() {
            // Set it here too or it will dissappear
            navigationItem.leftBarButtonItem = titleItem
        }
        navigationItem.rightBarButtonItems = [ settingsItem, searchItem ]
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == self.coinTickers.count ? 120 : 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Add +1 for the last cell (add coin)
        return self.coinTickers.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row != self.coinTickers.count {
            let cell = tableView.dequeueReusableCell(MainCoinTickerCell.self, for: indexPath)
            let coin = self.coinTickers[indexPath.row]
            cell.configureWithModel(coin)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(MainAddCoinCell.self, for: indexPath)
            cell.configureLabel(font: .cryptoRegularLarge, numberOfLines: 1)
            cell.label.text = "Add Coin"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow()
    }
}


