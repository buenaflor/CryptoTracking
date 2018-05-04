//
//  MainHeaderView.swift
//  CryptoTracking
//
//  Created by Giancarlo on 24.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit
import RealmSwift

protocol MainHeaderViewDelegate: class {
    func mainHeaderViewSortCoins(_ mainHeaderView: MainHeaderView)
    func mainHeaderViewSortHolding(_ mainHeaderView: MainHeaderView)
    func mainHeaderViewSortPrice(_ mainHeaderView: MainHeaderView)
    func mainHeaderView(_ mainHeaderView: MainHeaderView, didClick totalHolding: Double)
    func mainHeaderView(_ mainHeaderView: MainHeaderView, didClick percentage: Float)
    func mainHeaderView(_ mainHeaderView: MainHeaderView, didChange segmentedControl: UISegmentedControl)
}

class MainHeaderView: BaseView {
    
    weak var delegate: MainHeaderViewDelegate?
    
    var percentage24h = 0.0
    var allTimePct = 0.0
    
    var finalCoinData: [FinalCoinData]? {
        didSet {
            
        }
    }
    
    override func loadData(force: Bool) {
        
        let realm = try! Realm()
        let coins = realm.objects(Coin.self)
        
        var portfolioValue = 0.0
        var winLosePercentage = 0.0
        var percentage24h = 0.0
        
        coins.forEach { (coin) in
            
            SessionManager.ccShared.start(call: CCClient.GetCoinData(tag: "top/exchanges/full", query: ["fsym": coin.symbol, "tsym": "EUR"])) { (result) in
                result.onSuccess { value in
                    
                    let finalCoinData = FinalCoinData(data: value.data, coin: coin)
                    
                    portfolioValue += finalCoinData.totalWorth
                    winLosePercentage += finalCoinData.winLosePercentage
                    percentage24h += finalCoinData.data.aggregatedData.changepct24Hour
                
                    self.percentage24h = percentage24h
                    self.allTimePct = winLosePercentage
                    
                    self.segmentedValueLabel.text = self.segmentedControl.selectedSegmentIndex == 0 ? "\(winLosePercentage.roundToTwoDigits())%" : "\(percentage24h.roundToTwoDigits())%"
                    
                    if self.segmentedControl.selectedSegmentIndex == 0 {
                        self.segmentedValueLabel.textColor = winLosePercentage.roundToTwoDigits() < 0 ? .red : .green
                    }
                    else {
                        self.segmentedValueLabel.textColor = percentage24h.roundToTwoDigits() < 0 ? .red : .green
                    }
                    
                    self.currencySymbolLabel.text = Accessible.shared.currentUsedCurrencySymbol
                    self.portfolioValueLabel.text = "\((portfolioValue / Accessible.Currency.convertedValue).roundToTwoDigits())"
                    
                    self.coinLabel.textColor = .gray
                    self.holdingsLabel.textColor = .gray
                    self.priceLabel.textColor = .gray
                    self.portfolioLabel.textColor = UIColor.CryptoTracking.darkTint
                    self.portfolioValueLabel.textColor = UIColor.CryptoTracking.darkTint
                    self.currencySymbolLabel.textColor = UIColor.CryptoTracking.darkTint
                    
                    }.onError { error in
                        print(error)
                }
            }
        }
    }
    
    let barView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8653691192, green: 0.8653691192, blue: 0.8653691192, alpha: 1)
        return view
    }()
    
    let coinLabel = Label(font: .cryptoMedium, numberOfLines: 1)
    let holdingsLabel = Label(font: .cryptoMedium, numberOfLines: 1)
    let priceLabel = Label(font: .cryptoMedium, numberOfLines: 1)
    let portfolioLabel = Label(font: .cryptoMedium, numberOfLines: 1)
    let portfolioValueLabel = Label(font: .cryptoBoldExtraLarge, numberOfLines: 1)
    let currencySymbolLabel = Label(font: .cryptoBold, numberOfLines: 1)
    
    lazy var segmentedValueLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .green
        return lbl
    }()
    
    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["ALL-TIME", "1D"])
        sc.selectedSegmentIndex = 0
        sc.backgroundColor = .clear
        sc.tintColor = .lightGray
        sc.addTarget(self, action: #selector(segmentedControlTapped(sender:)), for: .valueChanged)
        return sc
    }()
    
    init(finalCoinData: [FinalCoinData]) {
        super.init(frame: .zero)
        self.finalCoinData = finalCoinData
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        coinLabel.text = "Coin"
        holdingsLabel.text = "Holdings"
        priceLabel.text = "Price"
        portfolioLabel.text = "Total Portfolio Value"
    
        
        backgroundColor = UIColor.CryptoTracking.darkMain
        
        coinLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(coinLabelTapped(sender:))))
        
        add(subview: portfolioLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 10),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 25)
            ]}
        
        add(subview: segmentedControl) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 10),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -25),
            v.heightAnchor.constraint(equalToConstant: 20),
            v.widthAnchor.constraint(equalToConstant: 130)
            ]}
        
        add(subview: segmentedValueLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 12),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -60)
            ]}
        
        add(subview: portfolioValueLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: portfolioLabel.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 25)
            ]}
        
        add(subview: currencySymbolLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: portfolioValueLabel.topAnchor, constant: 5),
            v.trailingAnchor.constraint(equalTo: portfolioValueLabel.leadingAnchor)
            ]}
        
        add(subview: barView) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalToConstant: 38)
            ]}
        
        barView.add(subview: coinLabel) { (v, p) in [
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 32),
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor)
            ]}
        
        barView.add(subview: holdingsLabel) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor)
            ]}
        
        barView.add(subview: priceLabel) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.leadingAnchor.constraint(equalTo: holdingsLabel.trailingAnchor, constant: 70)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func coinLabelTapped(sender: UITapGestureRecognizer) {
        delegate?.mainHeaderViewSortCoins(self)
    }
    
    @objc func segmentedControlTapped(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 1 {
            segmentedValueLabel.text = "\(percentage24h.roundToTwoDigits())%"
            segmentedValueLabel.textColor = percentage24h < 0.0 ? .red : .green
        }
        else {
            segmentedValueLabel.text = "\(allTimePct.roundToTwoDigits())%"
            segmentedValueLabel.textColor = allTimePct < 0.0 ? .red : .green
        }
        
        NotificationCenter.default.post(name: .changePercentages, object: sender.selectedSegmentIndex)
    }
    
}
