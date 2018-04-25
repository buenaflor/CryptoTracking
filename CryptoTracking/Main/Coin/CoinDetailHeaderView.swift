//
//  CoinDetailHeaderView.swift
//  CryptoTracking
//
//  Created by Giancarlo on 25.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class CoinDetailHeaderView: UIView, LoadingController {
    
    func loadData(force: Bool) {
        
        let profitAttributedString = NSMutableAttributedString(string: "All Time Profit: ", attributes: [NSAttributedStringKey.font: UIFont.cryptoRegularLarge])
        profitAttributedString.append(NSAttributedString(string: "€ 199.12", attributes: [NSAttributedStringKey.foregroundColor: UIColor.green]))
        profitLabel.attributedText = profitAttributedString
        
        let portfolioAttributedString = NSMutableAttributedString(string: "Portfolio", attributes: [NSAttributedStringKey.font: UIFont.cryptoRegularMedium, NSAttributedStringKey.foregroundColor: UIColor.gray])
        portfolioAttributedString.append(NSAttributedString(string: "\n300 XRP", attributes: [NSAttributedStringKey.font: UIFont.cryptoRegularLarge]))
        portfolioLabel.attributedText = portfolioAttributedString
        
        let marketValueLabelAttributedString = NSMutableAttributedString(string: "Market Value", attributes: [NSAttributedStringKey.font: UIFont.cryptoRegularMedium, NSAttributedStringKey.foregroundColor: UIColor.gray])
        marketValueLabelAttributedString.append(NSAttributedString(string: "\n€0.51", attributes: [NSAttributedStringKey.font: UIFont.cryptoRegularLarge]))
        marketValueLabel.attributedText = marketValueLabelAttributedString
        
        let netCostAttributedString = NSMutableAttributedString(string: "Net Cost", attributes: [NSAttributedStringKey.font: UIFont.cryptoRegularMedium, NSAttributedStringKey.foregroundColor: UIColor.gray])
        netCostAttributedString.append(NSAttributedString(string: "\n€301.23", attributes: [NSAttributedStringKey.font: UIFont.cryptoRegularLarge]))
        netCostLabel.attributedText = netCostAttributedString
        
        portfolioLabel.textAlignment = .center
        netCostLabel.textAlignment = .center
        marketValueLabel.textAlignment = .center
    }
    
    func changed() {}
    
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
        btn.backgroundColor = .lightGray
        btn.setAttributedTitle(NSAttributedString(string: "Transactions", attributes: [NSAttributedStringKey.font : UIFont.cryptoRegularLarge]), for: .normal)
        btn.addTarget(self, action: #selector(transactionsButtonTapped(sender:)), for: .touchUpInside)
        return btn
    }()
    
    let generalButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .lightGray
        btn.setAttributedTitle(NSAttributedString(string: "General", attributes: [NSAttributedStringKey.font : UIFont.cryptoRegularLarge]), for: .normal)
        btn.addTarget(self, action: #selector(generalButtonTapped(sender:)), for: .touchUpInside)
        return btn
    }()
    
    let alertButton: UIButton = {
        let btn = UIButton()
        btn.setAttributedTitle(NSAttributedString(string: "Alert", attributes: [NSAttributedStringKey.font : UIFont.cryptoRegularLarge]), for: .normal)
        btn.backgroundColor = .lightGray
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
            v.heightAnchor.constraint(equalToConstant: 70)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func transactionsButtonTapped(sender: UIButton) {
        print("bruder")
    }
    
    @objc func generalButtonTapped(sender: UIButton) {
        
    }
    
    @objc func alertButtonTapped(sender: UIButton) {
        
    }
}