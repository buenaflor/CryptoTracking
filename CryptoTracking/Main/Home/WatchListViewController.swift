//
//  WatchListViewController.swift
//  CryptoTracking
//
//  Created by Giancarlo on 03.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit
import RealmSwift

class WatchListViewController: MainController, UITableViewDelegate, UITableViewDataSource {
    
    let addButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "cryptoTracking_plus_100px").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .gray
        return btn
    }()
    
    let containerView = UIView()
    
    override func loadData(force: Bool) {
        let realm = try! Realm()
        let coins = realm.objects(Coin.self)
        
        var tempFinalCoinData = [FinalCoinData]()
        coins.forEach { (coin) in
            
            if !coin.transactions.contains(where: { (transaction) -> Bool in
                if transaction.transactionType == 3 {
                    return true
                }
                else {
                    return false
                }
            }) {
                SessionManager.ccShared.start(call: CCClient.GetCoinData(tag: "top/exchanges/full", query: ["fsym": coin.symbol, "tsym": "EUR"])) { (result) in
                    result.onSuccess { value in
                        
                        let finalCoinData = FinalCoinData(data: value.data, coin: coin)
                        tempFinalCoinData.append(finalCoinData)
                        self.finalCoinData = tempFinalCoinData
                        self.activityIndicator.stopAnimating()
                        self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                        print("succu")
                        }.onError { error in
                            print(error)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        view.fillToSuperview(containerView)
        containerView.fillToSuperview(tableView)
        
        containerView.add(subview: addButton) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor, constant: -80),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -20),
            v.heightAnchor.constraint(equalToConstant: 75),
            v.widthAnchor.constraint(equalToConstant: 75)
            ]}
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalCoinData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(MainCoinTickerCell.self, for: indexPath)
        
        cell.configureWithModel(finalCoinData[indexPath.row])
        
        return cell
    }
}
