//
//  ExchangeViewController.swift
//  CryptoTracking
//
//  Created by Giancarlo on 25.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class ExchangeViewController: BaseSearchViewController, LoadingController {
    
    // Stores the exchanges for the coin
    private var exchanges = [Exchange]()
    private var filteredExchanges = [Exchange]()
    
    private var coinSymbol = String()
    
    func loadData(force: Bool) {
        SessionManager.ccShared.start(call: CCClient.GetCoinData(tag: "top/exchanges/full", query: ["fsym": coinSymbol, "tsym": "USD"])) { (result) in
            result.onSuccess { value in
                self.exchanges = value.data.exchanges
                self.filteredExchanges = value.data.exchanges
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                }.onError { error in
                    print(error)
            }
        }
    }
    
    init(coinSymbol: String) {
        super.init(nibName: nil, bundle: nil)
        self.coinSymbol = coinSymbol
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

extension ExchangeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredExchanges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(TableViewCell.self, for: indexPath)
        
        cell.configureLabel(font: .cryptoRegular, numberOfLines: 1)
        cell.label.text = filteredExchanges[indexPath.row].market
        
        return cell
    }
}
