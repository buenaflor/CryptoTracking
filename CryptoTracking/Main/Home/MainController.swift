//
//  MainController.swift
//  CryptoTracking
//
//  Created by Giancarlo on 24.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit
import SDWebImage

// MARK: - Controller

class MainController: BaseViewController, LoadingController {
    
    func changed() { print("globally changed") }
 
    var coinTickers = [CoinTicker]()
    var coinData = [ExchangeDataClass]()
    
    func loadData(force: Bool) {
        
        SessionManager.ccShared.start(call: CCClient.GetCoinData(tag: "top/exchanges/full", query: ["fsym": "XRP", "tsym": "EUR"])) { (result) in
            result.onSuccess { value in
                self.coinData.append(value.data)
                self.activityIndicator.stopAnimating()
                self.navigationItem.leftBarButtonItem = self.titleItem
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                }.onError { error in
                    print(error)
            }
        }
    }
    
    // MARK: - View Declaration
    
    lazy var titleItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "CryptoTracker", style: .plain, target: nil, action: nil)
        item.isEnabled = false
        
        // doesn't work yet
        item.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.cryptoBoldLarge], for: .normal)
        return item
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(MainAddCoinCell.self)
        tv.register(MainCoinTickerCell.self)
        tv.backgroundColor = .lightGray
        tv.tableFooterView = UIView()
        return tv
    }()
    
    lazy var settingsItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: #imageLiteral(resourceName: "cryptoTracking_vertical_dots").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(settingsItemTapped(sender:)))
        return item
    }()
    
    lazy var searchItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: #imageLiteral(resourceName: "cryptoTracking_search").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(searchItemTapped(sender:)))
        return item
    }()

    
    // MARK: - Action
    
    @objc func settingsItemTapped(sender: UIBarButtonItem) {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    @objc func searchItemTapped(sender: UIBarButtonItem) {
        let vc = CryptoSearchViewController()
        vc.loadData(force: true)
        present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
}

// MARK: - Cells

class MainCoinTickerCell: UITableViewCell, Configurable {
    
    var model: ExchangeDataClass?
    
    func configureWithModel(_ dataClass: ExchangeDataClass) {
        self.model = dataClass
        
        symbolLabel.text = dataClass.coinInfo.name
        
        // Dollar Symbol only for testing
        currentPriceLabel.text = "\(Accessible.shared.currentUsedCurrency)\(dataClass.aggregatedData.price)"
        
        let rounded24hChange = (dataClass.aggregatedData.changepct24Hour * 100).rounded() / 100
        change24hLabel.text = "\(rounded24hChange)%"
        change24hLabel.textColor = rounded24hChange >= 0.0 ? .green : .red
        
        if let imageURLPath = dataClass.coinInfo.imageURL {
            iconImageView.sd_setImage(with: URL(string: "https://www.cryptocompare.com\(imageURLPath)")!)
        }
        
        // Test Data only - Model is still not ready
        holdingsLabel.text = "17.80%"
    }
    
    let symbolLabel: Label = {
        let lbl = Label(font: .cryptoBoldLarge, numberOfLines: 1)
        return lbl
    }()
    
    let holdingsLabel: Label = {
        let lbl = Label(font: .cryptoRegularLarge, numberOfLines: 1)
        lbl.textAlignment = .right
        return lbl
    }()
    
    let currentPriceLabel: Label = {
        let lbl = Label(font: .cryptoRegularLarge, numberOfLines: 1)
        lbl.textAlignment = .right
        return lbl
    }()
    
    let change24hLabel: Label = {
        let lbl = Label(font: .cryptoRegularLarge, numberOfLines: 1)
        lbl.textAlignment = .right
        return lbl
    }()
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        createConstraints()
    }
    
    func createConstraints() {
        
        add(subview: iconImageView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 5),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 32),
            v.heightAnchor.constraint(equalToConstant: 25),
            v.widthAnchor.constraint(equalToConstant: 25)
            ]}
        
        add(subview: symbolLabel) { (v, p) in [
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 32),
            v.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 8)
            ]}
        
        add(subview: holdingsLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 13),
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor)
            ]}
        
        add(subview: currentPriceLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 8),
            v.leadingAnchor.constraint(equalTo: holdingsLabel.trailingAnchor, constant: 8),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -50)
            ]}
        
        add(subview: change24hLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: currentPriceLabel.topAnchor, constant: 23),
            v.leadingAnchor.constraint(equalTo: holdingsLabel.trailingAnchor, constant: 8),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -50)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MainAddCoinCell: TableViewCell {
    
    let addButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "cryptoTracking_add").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .gray
        return btn
    }()
    
    override func addLabel() {
        add(subview: label) { (v, p) in [
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor, constant: 25)
            ]}
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        add(subview: addButton) { (v, p) in [
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor, constant: -18),
            v.heightAnchor.constraint(equalToConstant: 40),
            v.widthAnchor.constraint(equalToConstant: 40)
            ]}
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}











