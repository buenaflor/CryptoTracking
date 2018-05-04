//
//  WatchListViewController.swift
//  CryptoTracking
//
//  Created by Giancarlo on 03.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift

class WatchListViewController: MainController, UITableViewDelegate, UITableViewDataSource, ClickableDelegate {
    
    lazy var addButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(addButtonTapped(sender:)), for: .touchUpInside)
        btn.setImage(#imageLiteral(resourceName: "cryptoTracking_plus_100px").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .gray
        return btn
    }()
    
    lazy var headerView: WatchListHeader = {
        let view = WatchListHeader(frame: CGRect(x: 0, y: 0, width: 0, height: 55))
        view.delegate = self
        return view
    }()
    
    let containerView = UIView()
    
    override func loadData(force: Bool) {
        let realm = try! Realm()
        let coins = realm.objects(Coin.self)
        
        var tempFinalCoinData = [FinalCoinData]()
        
        coins.forEach { (coin) in
            if coin.transactions.contains(where: { (transaction) -> Bool in
                if transaction.transactionType == 3 {
                    return true
                }
                else {
                    return false
                }
            }) {
                SessionManager.ccShared.start(call: CCClient.GetCoinData(tag: "top/exchanges/full", query: ["fsym": coin.symbol, "tsym": "USD"])) { (result) in
                    result.onSuccess { value in
                        let finalCoinData = FinalCoinData(data: value.data, coin: coin)
                        tempFinalCoinData.append(finalCoinData)
                        
                        // Sorted as Highest Cap for default
                        self.finalCoinData = tempFinalCoinData.sorted { $0.data.aggregatedData.price < $1.data.aggregatedData.price }
                        
                        self.activityIndicator.stopAnimating()
                        self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                        }.onError { error in
                            print(error)
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pageVC?.tabbarView.hide(false, duration: 0.5, transition: .transitionCrossDissolve)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(WatchListTickerCell.self)
        tableView.tableHeaderView = headerView
        
        view.fillToSuperview(containerView)
        containerView.fillToSuperview(tableView)
        
        containerView.add(subview: addButton) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor, constant: -80),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -20),
            v.heightAnchor.constraint(equalToConstant: 75),
            v.widthAnchor.constraint(equalToConstant: 75)
            ]}
    }
    
    @objc func addButtonTapped(sender: UIButton) {
        let cryptoSearchVC = CryptoSearchViewController(addToWatchListOnly: true)
        cryptoSearchVC.loadData(force: true)
        present(cryptoSearchVC.wrapped(), animated: true, completion: nil)
    }
    
    func clicked(button: UIButton) {
        let alertController = UIAlertController(title: "Choose Filter", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Alphabetical", style: .default, handler: { (action) in
            self.finalCoinData = self.finalCoinData.sorted { $0.coin.name < $1.coin.name }
            self.headerView.filterButton.setTitle("Alphabetical", for: .normal)
            self.tableView.reloadData()
        }))
        
        alertController.addAction(UIAlertAction(title: "Highest Cap", style: .default, handler: { (action) in
            self.finalCoinData = self.finalCoinData.sorted {
                if let lhsMktCap = $0.data.aggregatedData.mktcap {
                    if let rhsMktCap = $1.data.aggregatedData.mktcap {
                        return lhsMktCap > rhsMktCap
                    }
                }
                return false
            }
            self.headerView.filterButton.setTitle("Highest Cap", for: .normal)
            self.tableView.reloadData()
        }))
        
        alertController.addAction(UIAlertAction(title: "Lowest Cap", style: .default, handler: { (action) in
            self.finalCoinData = self.finalCoinData.sorted {
                if let lhsMktCap = $0.data.aggregatedData.mktcap {
                    if let rhsMktCap = $1.data.aggregatedData.mktcap {
                        return lhsMktCap < rhsMktCap
                    }
                }
                return false
            }
            self.headerView.filterButton.setTitle("Lowest Cap", for: .normal)
            self.tableView.reloadData()
        }))
        
        alertController.addAction(UIAlertAction(title: "Highest Price", style: .default, handler: { (action) in
            self.finalCoinData = self.finalCoinData.sorted { $0.data.aggregatedData.price > $1.data.aggregatedData.price }
            self.headerView.filterButton.setTitle("Highest Price", for: .normal)
            self.tableView.reloadData()
        }))
        
        alertController.addAction(UIAlertAction(title: "Lowest Price", style: .default, handler: { (action) in
            self.finalCoinData = self.finalCoinData.sorted { $0.data.aggregatedData.price > $1.data.aggregatedData.price }
            self.headerView.filterButton.setTitle("Lowest Price", for: .normal)
            self.tableView.reloadData()
        }))
        
        alertController.addAction(UIAlertAction(title: "Biggest Gain", style: .default, handler: { (action) in
            self.finalCoinData = self.finalCoinData.sorted { $0.data.aggregatedData.changepct24Hour > $1.data.aggregatedData.changepct24Hour }
            self.headerView.filterButton.setTitle("Biggest Gain", for: .normal)
            self.tableView.reloadData()
        }))
        
        alertController.addAction(UIAlertAction(title: "Biggest Lose", style: .default, handler: { (action) in
            self.finalCoinData = self.finalCoinData.sorted { $0.data.aggregatedData.changepct24Hour < $1.data.aggregatedData.changepct24Hour }
            self.headerView.filterButton.setTitle("Biggest Lose", for: .normal)
            self.tableView.reloadData()
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalCoinData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(WatchListTickerCell.self, for: indexPath)
        
        cell.configureWithModel(finalCoinData[indexPath.row])
        cell.backgroundColor = #colorLiteral(red: 0.9044284326, green: 0.9044284326, blue: 0.9044284326, alpha: 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow()
        
        let coinDetailVC = CoinDetailViewController(coinSymbol: finalCoinData[indexPath.row].coin.symbol)
        pageVC?.tabbarView.hide(true, duration: 0.5, transition: .transitionCrossDissolve)
        navigationController?.pushViewController(coinDetailVC, animated: true)
    }
}

class WatchListHeader: UIView {
    
    weak var delegate: ClickableDelegate?
    
    lazy var filterButton: UIButton = {
        let somespace: CGFloat = 10
        let btn = UIButton()
        btn.setTitle("Highest Cap", for: .normal)
        btn.setTitleColor(.lightGray, for: .normal)
        btn.addTarget(self, action: #selector(filterButtonTapped(sender:)), for: .touchUpInside)
        return btn
    }()
    
    let buttonImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        buttonImageView.image = #imageLiteral(resourceName: "cryptoTracking_filterdown").withRenderingMode(.alwaysTemplate)
        buttonImageView.tintColor = .lightGray
        
        add(subview: buttonImageView) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor, constant: -15),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 25),
            v.heightAnchor.constraint(equalToConstant: 15),
            v.widthAnchor.constraint(equalToConstant: 15)
            ]}
        
        add(subview: filterButton) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor, constant: -5),
            v.leadingAnchor.constraint(equalTo: buttonImageView.trailingAnchor, constant: 5)
            ]}
        
        backgroundColor = #colorLiteral(red: 0.9044284326, green: 0.9044284326, blue: 0.9044284326, alpha: 1)
    }
    
    @objc func filterButtonTapped(sender: UIButton) {
        delegate?.clicked(button: sender)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WatchListTickerCell: UITableViewCell, Configurable {
    
    var model: FinalCoinData?
    
    func configureWithModel(_ finalCoinData: FinalCoinData) {
        self.model = finalCoinData
        
        coinNameLabel.text = finalCoinData.coin.name
        
        
        finalCoinData.data.exchanges.forEach { (exchange) in
            // test data
            if exchange.market == "Bitstamp" {
                
                percentageLabel.text = "\(exchange.changepct24Hour.roundToTwoDigits())%"
                percentageLabel.textColor = exchange.changepct24Hour.roundToTwoDigits() < 0 ? .red : .green
                
                if exchange.tosymbol != Accessible.shared.currentUsedCurrencyCode {
                    Accessible.shared.getCurrencyValueConverted(target: "USD") { (value) in
                        let attributedString = NSMutableAttributedString(string: "$\(exchange.price.roundToTwoDigits()) | ", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
                        attributedString.append(NSAttributedString(string: "\(Accessible.shared.currentUsedCurrencySymbol)\((exchange.price / value).roundToTwoDigits())", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray]))
                        self.currentPriceLabel.attributedText = attributedString
                    }
                }
                else {
                    currentPriceLabel.text = "\(Accessible.shared.currentUsedCurrencySymbol)\(exchange.price)"
                    currentPriceLabel.textColor = UIColor.CryptoTracking.darkTint
                }
            }
        }
        
//        finalCoinData.coin.transactions[0].exchangeName
//        finalCoinData.coin.transactions[0].tradingPair
        
        let tradingPairExchangeAttributedString = NSMutableAttributedString(string: "Bitstamp ", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        tradingPairExchangeAttributedString.append(NSAttributedString(string: "XRP/EUR", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray]))
        
        tradingPairExchangeLabel.attributedText = tradingPairExchangeAttributedString
        
        
        if let imgUrlPath = finalCoinData.data.coinInfo.imageURL {
            iconImageView.sd_setImage(with: URL(string: "https://www.cryptocompare.com\(imgUrlPath)")!)
            iconImageView.image = iconImageView.image?.withRenderingMode(.alwaysTemplate)
            iconImageView.tintColor = .white
        }
        
        coinNameLabel.textColor = UIColor.CryptoTracking.darkTint

    }
    
    let iconImageView = UIImageView()
    let containerView = UIView()
    let coinNameLabel = Label(font: .cryptoRegularLarge, numberOfLines: 1)
    let tradingPairExchangeLabel = Label(font: .cryptoRegular, numberOfLines: 1)
    let currentPriceLabel = Label(font: .cryptoRegularMedium, numberOfLines: 1)
    let percentageLabel = Label(font: .cryptoRegularLarge, numberOfLines: 1)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        containerView.backgroundColor = UIColor.CryptoTracking.darkMain
        containerView.layer.cornerRadius = 7
        
        add(subview: containerView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 10),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -20),
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor, constant: -10)
            ]}
        
        containerView.add(subview: iconImageView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 13),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20),
            v.heightAnchor.constraint(equalToConstant: 17),
            v.widthAnchor.constraint(equalToConstant: 17)
            ]}
        
        containerView.add(subview: coinNameLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 10),
            v.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 7)
            ]}
        
        containerView.add(subview: tradingPairExchangeLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: coinNameLabel.bottomAnchor, constant: 3),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20)
            ]}
        
        containerView.add(subview: percentageLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 10),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -20)
            ]}
        
        containerView.add(subview: currentPriceLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: percentageLabel.bottomAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -20)
            ]}
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
