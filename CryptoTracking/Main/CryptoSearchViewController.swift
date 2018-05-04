//
//  CryptoSearchViewController.swift
//  CryptoTracking
//
//  Created by Giancarlo on 25.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit
import RealmSwift

class CryptoSearchViewController: BaseSearchViewController, LoadingController {
    
    // MARK: - Initial Load
    
    var coinTickers = [CoinTicker]()
    var filteredCoinTickers = [CoinTicker]()
    var addToWatchlist = false
    
    func loadData(force: Bool) {
        SessionManager.cmcShared.start(call: CMCClient.GetSpecCurrencyTicker(tag: "ticker/")) { (result) in
            result.onSuccess { value in
                
                self.coinTickers = value.items
                self.filteredCoinTickers = value.items
                
                self.activityIndicator.stopAnimating()
                self.navigationItem.leftBarButtonItem = self.titleItem
                self.tableView.reloadData()
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
        let item = UIBarButtonItem(title: "CryptoTracking", style: .plain, target: nil, action: nil)
        item.isEnabled = false
        
        // doesn't work yet
        item.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.cryptoBoldLarge], for: .normal)
        return item
    }()

    var isSearching = false
    
    init(addToWatchListOnly: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.addToWatchlist = addToWatchListOnly
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // temporary until thememanager is fixed completely
        view.backgroundColor = .white
        view.fillToSuperview(tableView)
        
        tableView.register(TableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.becomeFirstResponder()
        searchController.searchBar.delegate = self
        
        updateView()
    }
    
    func updateView() {
        if !activityIndicatorAdded() {
            navigationItem.leftBarButtonItem = titleItem
        }
        
        navigationItem.rightBarButtonItem = exitItem
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    @objc func exitItemTapped(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension CryptoSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCoinTickers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(TableViewCell.self, for: indexPath)
        let coinName = filteredCoinTickers[indexPath.row].name
        let coinSymbol = filteredCoinTickers[indexPath.row].symbol
        
        cell.accessoryType = .disclosureIndicator
        cell.configureLabel(font: .cryptoRegularLarge, numberOfLines: 1)
        cell.label.text = "\(coinName): \(coinSymbol)"
        cell.label.textColor = UIColor.CryptoTracking.darkMain
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow()
        if !addToWatchlist {
            let coinSymbol = filteredCoinTickers[indexPath.row].symbol
            let coinName = filteredCoinTickers[indexPath.row].name
            let vc = TransactionViewController(coinSymbol: coinSymbol, coinName: coinName)
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            
            // BUG: Still no efficient solution for searching suitable Trading Pairs on exchanges
            let realm = try! Realm()
            let coins = realm.objects(Coin.self)
            
//            for coin in coins {
//                if coin.name == filteredCoinTickers[indexPath.row].name && coin.symbol == filteredCoinTickers[indexPath.row].symbol && coin.transactions.count == 0 {
//                    print("no transactions")
//                }
//                else {
//                    print("coin doesnt exist?")
//                    break
//                }
//            }
            
            for coin in coins {
                if coin.name == filteredCoinTickers[indexPath.row].name && coin.symbol == filteredCoinTickers[indexPath.row].symbol {
                    if coin.transactions.count != 0 {
                        print("there is ")
                    }
                    
                    for transaction in coin.transactions {
                        if transaction.transactionType == 3 {
                            
                        }
                    }
                }
            }

//            let watchListTransaction = Transaction()
//            watchListTransaction.transactionType = 3
//
//            let watchListCoin = Coin()
//            watchListCoin.symbol = filteredCoinTickers[indexPath.row].symbol
//            watchListCoin.name = filteredCoinTickers[indexPath.row].name
//            watchListCoin.transactions.append(watchListTransaction)
//
//            let dataCoin = Coin()
//            dataCoin.symbol = filteredCoinTickers[indexPath.row].symbol
//            dataCoin.name = filteredCoinTickers[indexPath.row].name
//
//            try! realm.write {
//                realm.add(watchListCoin)
//                print("added to watchlist")
//                realm.add(dataCoin)
//                print("added datacoin")
//                dismiss(animated: true, completion: nil)
//            }
        }
    }
}

extension CryptoSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            isSearching = true
            filteredCoinTickers = coinTickers.filter({
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.symbol.lowercased().contains(searchText.lowercased())
            })
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
        else {
            isSearching = false
            filteredCoinTickers = coinTickers
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
}
