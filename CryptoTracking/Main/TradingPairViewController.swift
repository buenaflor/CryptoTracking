//
//  TradingPairViewController.swift
//  CryptoTracking
//
//  Created by Giancarlo on 25.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class TradingPairViewController: BaseSearchViewController, LoadingController {
    
    func loadData(force: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.fillToSuperview(tableView)
        
        tableView.register(TableViewCell.self)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension TradingPairViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(TableViewCell.self, for: indexPath)
        
        cell.configureLabel(font: .cryptoRegularLarge, numberOfLines: 1)
        cell.textLabel?.text = ""
        
        return cell
    }
}
