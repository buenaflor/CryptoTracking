//
//  CurrencySettingsViewController.swift
//  CryptoTracking
//
//  Created by Giancarlo on 24.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class CurrencySettingsViewController: BaseSearchViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.fillToSuperview(tableView)
        
        tableView.register(TableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.searchBar.delegate = self
    }
}

extension CurrencySettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Currencies.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(TableViewCell.self, for: indexPath)
        
        cell.configureLabel(font: .cryptoRegularLarge, numberOfLines: 1)

        cell.label.text = Array(Currencies.list)[indexPath.row].value

        
        return cell
    }
}

extension CurrencySettingsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
}
