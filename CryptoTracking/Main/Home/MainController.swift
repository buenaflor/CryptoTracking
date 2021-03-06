//
//  MainController.swift
//  CryptoTracking
//
//  Created by Giancarlo on 24.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift

struct FinalCoinData {
    let data: ExchangeDataClass
    let coin: Coin
}

extension FinalCoinData {
    
    var winLosePercentage: Double {
        var worth = 0.0
        var cost = 0.0
        
        self.coin.transactions.forEach({ (transaction) in
            if transaction.transactionType != 3 {
                // Cost during buy
                cost += transaction.amount * transaction.price
                
                // Its worth now
                worth += transaction.amount * self.data.aggregatedData.price
            }
        })
        
        var winLosePercentage = (((worth / cost) - 1) * 100)
        winLosePercentage = (winLosePercentage * 1000).rounded() / 1000
        print("winlose", winLosePercentage)
        
        return winLosePercentage
    }
    
    var allTimeProfit: Double {
        var worth = 0.0
        var cost = 0.0
        
        self.coin.transactions.forEach({ (transaction) in
            if transaction.transactionType != 3 {
                // Cost during buy
                cost += transaction.amount * transaction.price
                
                // Its worth now
                worth += transaction.amount * self.data.aggregatedData.price
            }
        })
        
        return worth - cost
    }
    
    var totalAmount: Double {
        var amount = 0.0
        
        self.coin.transactions.forEach({ (transaction) in
            if transaction.transactionType != 3 {
                amount += transaction.amount
            }
        })
        
        return amount
    }
    
    var totalWorth: Double {
        var worth = 0.0
        
        self.coin.transactions.forEach({ (transaction) in
            if transaction.transactionType != 3 {
                worth += transaction.amount * self.data.aggregatedData.price
            }
        })
        
        return worth
    }
    
    var netCost: Double {
        var netCost = 0.0
        
        self.coin.transactions.forEach({ (transaction) in
            if transaction.transactionType != 3 {
                netCost += transaction.amount * transaction.price
            }
        })
        
        return netCost
    }
    
    var currentPrice: Double {
        return self.data.aggregatedData.price
    }
}

// MARK: - Controller

class MainController: BaseViewController, LoadingController {
    
    var finalCoinData = [FinalCoinData]()
    
    func loadData(force: Bool) {
        
        let realm = try! Realm()
        let coins = realm.objects(Coin.self)
        
        var tempFinalCoinData = [FinalCoinData]()
        if coins.count != 0 {
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
                            self.navigationItem.leftBarButtonItem = self.titleItem
                            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                            
                            }.onError { error in
                                print(error)
                        }
                    }
                }
            }
        }
        else {
            self.activityIndicator.stopAnimating()
            self.navigationItem.leftBarButtonItem = self.titleItem
        }
    }
    
    let pageVC: TabbarCollectionViewController?
    
    init(pageVC: TabbarCollectionViewController) {
        self.pageVC = pageVC
        super.init(nibName: nil, bundle: nil)
    }
    
    var unwrappedPageVC: TabbarCollectionViewController {
        guard let pageVC = pageVC else { return TabbarCollectionViewController() }
        return pageVC
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        tv.backgroundColor = #colorLiteral(red: 0.9044284326, green: 0.9044284326, blue: 0.9044284326, alpha: 1)
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
    
    lazy var mainHeaderView: MainHeaderView = {
        let view = MainHeaderView()
        view.loadData(force: true)
        return view
    }()

    
    // MARK: - Action
    
    @objc func settingsItemTapped(sender: UIBarButtonItem) {
        unwrappedPageVC.tabbarView.hide(true, duration: 0.15, transition: .transitionCrossDissolve)
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    @objc func searchItemTapped(sender: UIBarButtonItem) {
        unwrappedPageVC.tabbarView.hide(true, duration: 0.15, transition: .transitionCrossDissolve)
        let vc = CryptoSearchViewController(addToWatchListOnly: false)
        vc.loadData(force: true)
        present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
}

// MARK: - Cells

class MainCoinTickerCell: UITableViewCell, Configurable {
    
    var model: FinalCoinData?
    
    var allTimePct = 0.0
    var percentage24h = 0.0
    
    func configureWithModel(_ dataClass: FinalCoinData) {
        self.model = dataClass
        
        Accessible.shared.getPortfolioValue(completion: { (portfolioValue) in
            
            if Accessible.Currency.convertedValue == 0.0 {
                NotificationCenter.default.post(name: .reloadTableView, object: nil)
            }
            
            let roundedPrice = (dataClass.data.aggregatedData.price / Accessible.Currency.convertedValue * 1000).rounded() / 1000
            
            self.allTimePct = dataClass.winLosePercentage
            self.percentage24h = dataClass.data.aggregatedData.changepct24Hour
            
            self.symbolLabel.text = dataClass.data.coinInfo.name
            self.currentPriceLabel.text = "\(Accessible.shared.currentUsedCurrencySymbol)\(roundedPrice)"
            
            self.change24hLabel.text = dataClass.winLosePercentage >= 0.0 ? "+\(dataClass.winLosePercentage)%" : "\(dataClass.winLosePercentage)%"
            self.change24hLabel.textColor = dataClass.winLosePercentage >= 0.0 ? .green : .red
            
            self.holdingsLabel.text = "\(((dataClass.totalWorth / portfolioValue) * 100).roundToTwoDigits())%"
            self.totalWorthLabel.text = "\(Accessible.shared.currentUsedCurrencySymbol)\(dataClass.totalWorth.roundToTwoDigits())"
            
            if let imageURLPath = dataClass.data.coinInfo.imageURL {
                self.iconImageView.sd_setImage(with: URL(string: "https://www.cryptocompare.com\(imageURLPath)")!)
            }
            
            self.symbolLabel.textColor = UIColor.CryptoTracking.darkTint
            self.holdingsLabel.textColor = UIColor.CryptoTracking.darkTint
            self.currentPriceLabel.textColor = UIColor.CryptoTracking.darkTint
            self.totalWorthLabel.textColor = UIColor.CryptoTracking.darkTint
        })
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
    
    let totalWorthLabel: Label = {
        let lbl = Label(font: .cryptoRegularLarge, numberOfLines: 1)
        lbl.textAlignment = .right
        return lbl
    }()
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    let containerView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        createConstraints()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(changePercentageReceived(sender:)),
                                       name: .changePercentages,
                                       object: nil)
    }
    
    func createConstraints() {
        
        containerView.backgroundColor = UIColor.CryptoTracking.darkMain
        containerView.layer.cornerRadius = 7
        
        add(subview: containerView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 10),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -20),
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor, constant: -10)
            ]}
        
        containerView.add(subview: iconImageView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 8),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 35),
            v.heightAnchor.constraint(equalToConstant: 25),
            v.widthAnchor.constraint(equalToConstant: 25)
            ]}

        containerView.add(subview: symbolLabel) { (v, p) in [
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30),
            v.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 8)
            ]}

        containerView.add(subview: holdingsLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 13),
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor)
            ]}
        
        containerView.add(subview: totalWorthLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: holdingsLabel.bottomAnchor),
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor)
            ]}

        containerView.add(subview: currentPriceLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 8),
            v.leadingAnchor.constraint(equalTo: holdingsLabel.trailingAnchor, constant: 8),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -50)
            ]}

        containerView.add(subview: change24hLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: currentPriceLabel.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: holdingsLabel.trailingAnchor, constant: 8),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -50)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func changePercentageReceived(sender: Notification) {
        guard let selectedIndex = sender.object as? Int else { return }
        
        if selectedIndex == 1 {
            self.change24hLabel.text = "\(percentage24h.roundToTwoDigits())%"
            self.change24hLabel.textColor = percentage24h > 0.0 ? .green : .red
        }
        else {
            self.change24hLabel.text = "\(allTimePct.roundToTwoDigits())%"
            self.change24hLabel.textColor = allTimePct > 0.0 ? .green : .red
        }
    }
}

class MainAddCoinCell: TableViewCell {
    
    weak var delegate: ClickableDelegate?
    
    lazy var addButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "cryptoTracking_add").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .gray
        btn.addTarget(self, action: #selector(addButtonTapped(sender:)), for: .touchUpInside)
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
    
    @objc func addButtonTapped(sender: UIButton) {
        delegate?.clicked(button: sender)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}











