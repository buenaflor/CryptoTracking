//
//  CryptoSearchViewController.swift
//  CryptoTracking
//
//  Created by Giancarlo on 25.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class CryptoSearchViewController: BaseSearchViewController, LoadingController {
    
    var coinTickers = [CoinTicker]()
    
    func loadData(force: Bool) {
        SessionManager.shared.start(call: CMCClient.GetSpecCurrencyTicker(tag: "ticker/")) { (result) in
            result.onSuccess { value in
                self.coinTickers = value.items
                self.activityIndicator.stopAnimating()
                self.navigationItem.leftBarButtonItem = self.titleItem
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                }.onError { error in
                    print(error.localizedDescription)
            }
        }
    }
    
    // Still unused
    func changed() {}
    
    lazy var exitItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: #imageLiteral(resourceName: "cryptoTracking_exit").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(exitItemTapped(sender:)))
        return item
    }()

    lazy var titleItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Search Coins", style: .plain, target: nil, action: nil)
        item.isEnabled = false
        
        // doesn't work yet
        item.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.cryptoBoldLarge], for: .normal)
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // temporary until thememanager is fixed completely
        view.backgroundColor = .white
        view.fillToSuperview(tableView)
        
        tableView.register(UITableViewCell.self)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.searchBar.delegate = self
        
        updateView()
    }
    
    func updateView() {
        if !activityIndicatorAdded() {
            navigationItem.leftBarButtonItem = titleItem
        }
        navigationItem.rightBarButtonItem = exitItem
        navigationItem.searchController = searchController
    }
    
    @objc func exitItemTapped(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension CryptoSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinTickers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UITableViewCell.self, for: indexPath)
        
        cell.textLabel?.text = coinTickers[indexPath.row].name
        
        return cell
    }
}

extension CryptoSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("hello")
    }
}
