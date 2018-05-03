//
//  TradingPairViewController.swift
//  CryptoTracking
//
//  Created by Giancarlo on 25.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

protocol TradingPairViewControllerDelegate: class {
    func tradingPairViewController(_ tradingPairViewController: TradingPairViewController, didPick tradingPair: String)
}

class TradingPairViewController: BaseSearchViewController, LoadingController {
    
    weak var myDelegate: TradingPairViewControllerDelegate?
    
    var exchangeName: String?
    var coinSymbol: String?
    
    var tradingPairs = [String]()
    var filteredTradingPairs = [String]()
    
    func loadData(force: Bool) {
        
        guard let exchangeName = exchangeName, let coinSymbol = coinSymbol else {
            showAlert(title: "Erro", message: "Invalid input, something went wrong")
            return
        }
        
        SessionManager.cwShared.start(call: CWClient.GetMarkets(tag: "markets")) { (result) in
            result.onSuccess { value in
                let markets = value.result.filter({ (market) -> Bool in
                
                    if market.exchange == exchangeName.lowercased() {
                        return true
                    }
                    else {
                        if exchangeName == "Coinbase" && market.exchange == "gdax" {
                            return true
                        }
                        else {
                            return false
                        }
                    }
                })
                markets.forEach({ (market) in
                    if market.pair.contains(coinSymbol.lowercased()) {
                        if market.pair.prefix(3) == coinSymbol.lowercased() {
                            let pair = "\(market.pair.prefix(3).uppercased())/\(market.pair.suffix(3).uppercased())"
                            self.tradingPairs.append(pair)
                        }
                    }
                })
                
                self.filteredTradingPairs = self.tradingPairs
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                
                }.onError { error in
                    print(error)
            }
        }
    }
    
    init(exchangeName: String, coinSymbol: String) {
        super.init(nibName: nil, bundle: nil)
        self.exchangeName = exchangeName
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

extension TradingPairViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return filteredTradingPairs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(TableViewCell.self, for: indexPath)
        
        cell.configureLabel(font: .cryptoRegularLarge, numberOfLines: 1)
        cell.textLabel?.text = filteredTradingPairs[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow()
        navigationController?.popViewController(animated: true)
        myDelegate?.tradingPairViewController(self, didPick: filteredTradingPairs[indexPath.row])
    }
}
