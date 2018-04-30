//
//  MainHeaderView.swift
//  CryptoTracking
//
//  Created by Giancarlo on 24.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

protocol MainHeaderViewDelegate: class {
    func mainHeaderView(_ mainHeaderView: MainHeaderView, didClick sortedCoin: CoinTicker)
    func mainHeaderView(_ mainHeaderView: MainHeaderView, didClick sortedHolding: String)
    func mainHeaderView(_ mainHeaderView: MainHeaderView, didClick sortedPrice: Int)
    func mainHeaderView(_ mainHeaderView: MainHeaderView, didClick totalHolding: Double)
    func mainHeaderView(_ mainHeaderView: MainHeaderView, didClick percentage: Float)
}

class MainHeaderView: BaseView {
    
    override func loadData(force: Bool) {
        Accessible.shared.getCurrencyValueConverted(target: "EUR") { (value) in
            // If positive green // doesnt change yet
            self.segmentedValueLabel.text = "+102.54%"
            // Test Value
            self.portfolioValueLabel.text = "\((2131 / value * 1000).rounded() / 1000)"
        }
    }
    
    let barView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8653691192, green: 0.8653691192, blue: 0.8653691192, alpha: 1)
        return view
    }()
    
    let coinlabel = Label(font: .cryptoLight, numberOfLines: 1)
    let holdingsLabel = Label(font: .cryptoLight, numberOfLines: 1)
    let priceLabel = Label(font: .cryptoLight, numberOfLines: 1)
    let portfolioLabel = Label(font: .cryptoLight, numberOfLines: 1)
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        coinlabel.text = "Coin"
        holdingsLabel.text = "Holdings"
        priceLabel.text = "Price"
        portfolioLabel.text = "Total Portfolio Value"
        currencySymbolLabel.text = Accessible.shared.currentUsedCurrencySymbol
        
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
        
        barView.add(subview: coinlabel) { (v, p) in [
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
    
    @objc func segmentedControlTapped(sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
    }
    
}
