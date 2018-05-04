//
//  CoinDetailHeaderView.swift
//  CryptoTracking
//
//  Created by Giancarlo on 25.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class CoinDetailHeaderView: UIView, Configurable {
    
    weak var delegate: ClickableDelegate?
    
    var model: FinalCoinData?
    
    func configureWithModel(_ coinData: FinalCoinData) {
        self.model = coinData

        
        let profitAttributedString = NSMutableAttributedString(string: "All Time Profit: ", attributes: [NSAttributedStringKey.font: UIFont.cryptoRegularLarge, NSAttributedStringKey.foregroundColor: UIColor.CryptoTracking.darkTint])
        profitAttributedString.append(NSAttributedString(string: "\(Accessible.shared.currentUsedCurrencySymbol)\(coinData.allTimeProfit)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.green]))
        profitLabel.attributedText = profitAttributedString
        
        let portfolioAttributedString = NSMutableAttributedString(string: "Portfolio", attributes: [NSAttributedStringKey.font: UIFont.cryptoRegularMedium, NSAttributedStringKey.foregroundColor: UIColor.gray])
        portfolioAttributedString.append(NSAttributedString(string: "\n\(coinData.totalAmount) \(coinData.data.coinInfo.name)", attributes: [NSAttributedStringKey.font: UIFont.cryptoRegularLarge, NSAttributedStringKey.foregroundColor: UIColor.CryptoTracking.darkTint]))
        portfolioLabel.attributedText = portfolioAttributedString
        
        let marketValueLabelAttributedString = NSMutableAttributedString(string: "Market Value", attributes: [NSAttributedStringKey.font: UIFont.cryptoRegularMedium, NSAttributedStringKey.foregroundColor: UIColor.gray])
        marketValueLabelAttributedString.append(NSAttributedString(string: "\n\(Accessible.shared.currentUsedCurrencySymbol)\(coinData.totalWorth)", attributes: [NSAttributedStringKey.font: UIFont.cryptoRegularLarge, NSAttributedStringKey.foregroundColor: UIColor.CryptoTracking.darkTint]))
        marketValueLabel.attributedText = marketValueLabelAttributedString
        
        let netCostAttributedString = NSMutableAttributedString(string: "Net Cost", attributes: [NSAttributedStringKey.font: UIFont.cryptoRegularMedium, NSAttributedStringKey.foregroundColor: UIColor.gray])
        netCostAttributedString.append(NSAttributedString(string: "\n\(Accessible.shared.currentUsedCurrencySymbol)\(coinData.netCost)", attributes: [NSAttributedStringKey.font: UIFont.cryptoRegularLarge, NSAttributedStringKey.foregroundColor: UIColor.CryptoTracking.darkTint]))
        netCostLabel.attributedText = netCostAttributedString
        
        portfolioLabel.backgroundColor = UIColor.CryptoTracking.darkMain
        marketValueLabel.backgroundColor = UIColor.CryptoTracking.darkMain
        netCostLabel.backgroundColor = UIColor.CryptoTracking.darkMain
        
        portfolioLabel.textAlignment = .center
        netCostLabel.textAlignment = .center
        marketValueLabel.textAlignment = .center
        
    }
    
    func loadPosition(x: CGFloat) {
        separatorView.transform = CGAffineTransform(translationX: x / 3, y: 0)
    }
    
    let profitLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.numberOfLines = 1
        return lbl
    }()
    
    let portfolioLabel = TextView(isEditable: false)
    let netCostLabel = TextView(isEditable: false)
    let marketValueLabel = TextView(isEditable: false)
    
    let transactionsButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(red:0.15, green:0.16, blue:0.23, alpha:1.0)
        btn.setAttributedTitle(NSAttributedString(string: "Transactions", attributes: [NSAttributedStringKey.font : UIFont.cryptoRegularLarge, NSAttributedStringKey.foregroundColor: UIColor.white]), for: .normal)
        btn.addTarget(self, action: #selector(transactionsButtonTapped(sender:)), for: .touchUpInside)
        return btn
    }()
    
    let generalButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(red:0.15, green:0.16, blue:0.23, alpha:1.0)
        btn.setAttributedTitle(NSAttributedString(string: "General", attributes: [NSAttributedStringKey.font : UIFont.cryptoRegularLarge, NSAttributedStringKey.foregroundColor: UIColor.white]), for: .normal)
        btn.addTarget(self, action: #selector(generalButtonTapped(sender:)), for: .touchUpInside)
        return btn
    }()
    
    let alertButton: UIButton = {
        let btn = UIButton()
        btn.setAttributedTitle(NSAttributedString(string: "Alert", attributes: [NSAttributedStringKey.font : UIFont.cryptoRegularLarge, NSAttributedStringKey.foregroundColor: UIColor.white]), for: .normal)
        btn.backgroundColor = UIColor(red:0.15, green:0.16, blue:0.23, alpha:1.0)
        btn.addTarget(self, action: #selector(alertButtonTapped(sender:)), for: .touchUpInside)
        return btn
    }()

    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [ portfolioLabel, marketValueLabel, netCostLabel ])
        sv.distribution = .fillEqually
        return sv
    }()
    
    lazy var buttonStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [ generalButton, transactionsButton, alertButton ])
        sv.distribution = .fillEqually
        return sv
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.CryptoTracking.darkMain
        
        add(subview: profitLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor, constant: 20),
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor)
            ]}
        
        add(subview: stackView) { (v, p) in [
            v.topAnchor.constraint(equalTo: profitLabel.bottomAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalToConstant: 60)
            ]}
        
        add(subview: buttonStackView) { (v, p) in [
            v.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalToConstant: 55)
            ]}
        
        add(subview: separatorView) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor),
            v.widthAnchor.constraint(equalTo: generalButton.widthAnchor),
            v.heightAnchor.constraint(equalToConstant: 3)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func generalButtonTapped(sender: UIButton) {
        sender.tag = 1
        delegate?.clicked(button: sender)
    }
    
    @objc func transactionsButtonTapped(sender: UIButton) {
        sender.tag = 2
        delegate?.clicked(button: sender)
    }
    
    @objc func alertButtonTapped(sender: UIButton) {
        sender.tag = 3
        delegate?.clicked(button: sender)
    }
}
