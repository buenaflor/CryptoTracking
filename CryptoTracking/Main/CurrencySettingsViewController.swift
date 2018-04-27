//
//  CurrencySettingsViewController.swift
//  CryptoTracking
//
//  Created by Giancarlo on 24.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class CurrencySettingsViewController: BaseSearchViewController, LoadingController {
    
    var currencyList = [String: CurrencyResponse]()
    var filteredCurrencyList = [String: CurrencyResponse]()
    
    var isSearching = false
    
    func loadData(force: Bool) {
        CurrencyManager.shared.currencyList { (currencies) in
            self.currencyList = currencies
            self.filteredCurrencyList = currencies
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.fillToSuperview(tableView)
        
        tableView.register(TableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension CurrencySettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCurrencyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(TableViewCell.self, for: indexPath)
        
        let currencySymbolNative = Array(filteredCurrencyList)[indexPath.row].value.symbolNative
        let currencyCode = Array(filteredCurrencyList)[indexPath.row].value.code
        let currencyName = Array(filteredCurrencyList)[indexPath.row].value.name
        
        cell.configureLabel(font: .cryptoRegularLarge, numberOfLines: 1)
        cell.label.text = "\(currencySymbolNative) \(currencyName) (\(currencyCode))"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow()
        
        let currencyCode = Array(filteredCurrencyList)[indexPath.row].value.code
        Accessible.shared.setCurrency(code: currencyCode)
        
        print(Accessible.shared.currentUsedCurrency)
        
        navigationController?.popViewController(animated: true)
        print("heyho")
    }
}

extension CurrencySettingsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            isSearching = true
            filteredCurrencyList = currencyList.filter({
                $0.value.name.lowercased().contains(searchText.lowercased()) ||
                $0.value.symbol.lowercased().contains(searchText.lowercased()) ||
                $0.value.symbolNative.lowercased().contains(searchText.lowercased()) ||
                $0.value.code.lowercased().contains(searchText.lowercased())
            })
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
        else {
            isSearching = false
            filteredCurrencyList = currencyList
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
}
