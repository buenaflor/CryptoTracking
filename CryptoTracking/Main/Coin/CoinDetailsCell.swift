//
//  CoinDetailsCell.swift
//  CryptoTracking
//
//  Created by Giancarlo on 02.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class CoinDetailCell: UICollectionViewCell, Configurable {
    
    var model: FinalCoinData?
    
    func configureWithModel(_ finalCoinData: FinalCoinData) {
        self.model = finalCoinData
        let marketCapValue = "\((finalCoinData.data.aggregatedData.mktcap! / Accessible.Currency.convertedValue).roundToTwoDigits())"
        let volume24h = "\((finalCoinData.data.aggregatedData.totalvolume24Hto! / Accessible.Currency.convertedValue).roundToTwoDigits())"
        let low24h = "\((finalCoinData.data.aggregatedData.low24Hour / Accessible.Currency.convertedValue).roundToTwoDigits())"
        let high24h = "\((finalCoinData.data.aggregatedData.high24Hour / Accessible.Currency.convertedValue).roundToTwoDigits())"
        let circSupply = "\((finalCoinData.data.aggregatedData.supply / Accessible.Currency.convertedValue).roundToTwoDigits())"
        
        // still has to be improved
//        var firstAdded = false
//        for (index, _) in marketCapValue.enumerated() {
//
//            if !firstAdded {
//                if index % 3 == 0 {
//                    let strIndex = marketCapValue.index(marketCapValue.startIndex, offsetBy: index)
//                    marketCapValue.insert(",", at: strIndex)
//                    firstAdded = true
//                }
//            }
//            else {
//                if index % 3 == 0 {
//                    let strIndex = marketCapValue.index(marketCapValue.startIndex, offsetBy: index + 4)
//                    marketCapValue.insert(",", at: strIndex)
//                }
//            }
//
//        }
        
        priceLabel.text = "\(Accessible.shared.currentUsedCurrencySymbol)\(finalCoinData.data.aggregatedData.price.roundToTwoDigits())"
        marketCapValueLabel.text = "\(Accessible.shared.currentUsedCurrencySymbol)\(marketCapValue)"
        volume24hValueLabel.text = "\(Accessible.shared.currentUsedCurrencySymbol)\(volume24h)"
        low24hValueLabel.text = "\(Accessible.shared.currentUsedCurrencySymbol)\(low24h)"
        high24hValueLabel.text = "\(Accessible.shared.currentUsedCurrencySymbol)\(high24h)"
        circSupplyValueLabel.text = "\(circSupply) \(finalCoinData.coin.symbol)"
    }
    
    let priceLabel = Label(font: .cryptoBoldExtraLarge, numberOfLines: 1)
    let globalMarketLabel = Label(font: .cryptoBoldLarge, numberOfLines: 1)
    let marketCapLabel = Label(font: .cryptoRegular, numberOfLines: 1)
    let volume24hLabel = Label(font: .cryptoRegular, numberOfLines: 1)
    let low24hLabel = Label(font: .cryptoRegular, numberOfLines: 1)
    let high24hLabel = Label(font: .cryptoRegular, numberOfLines: 1)
    let circSupplyLabel = Label(font: .cryptoRegular, numberOfLines: 1)
    
    let marketCapValueLabel = Label(font: .cryptoBoldLarge, numberOfLines: 1)
    let volume24hValueLabel = Label(font: .cryptoMedium, numberOfLines: 1)
    let low24hValueLabel = Label(font: .cryptoMedium, numberOfLines: 1)
    let high24hValueLabel = Label(font: .cryptoMedium, numberOfLines: 1)
    let circSupplyValueLabel = Label(font: .cryptoMedium, numberOfLines: 1)
    
    let containerTopView = UIView()
    let containerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 5
        view.backgroundColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.9044284326, green: 0.9044284326, blue: 0.9044284326, alpha: 1)
        globalMarketLabel.textColor = .lightGray
        
        globalMarketLabel.text = "GLOBAL MARKET"
        marketCapLabel.text = "Market Cap"
        volume24hLabel.text = "Volume (24h)"
        low24hLabel.text = "Low (24h)"
        high24hLabel.text = "High (24h)"
        circSupplyLabel.text = "Circulating Supply"
        
        add(subview: priceLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 30),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30)
            ]}
        
        add(subview: containerView) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor, constant: -30),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -20),
            v.heightAnchor.constraint(equalToConstant: 220)
            ]}
        
        add(subview: globalMarketLabel) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -10),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20)
            ]}
        
        containerView.add(subview: containerTopView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.3)
            ]}
        
        containerTopView.addSeparatorLine(color: .lightGray)
        
        containerTopView.add(subview: marketCapLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 10),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 10)
            ]}
        
        containerTopView.add(subview: marketCapValueLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: marketCapLabel.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 10)
            ]}
        
        containerView.add(subview: volume24hLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: containerTopView.bottomAnchor, constant: 10),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 10)
            ]}
        
        containerView.add(subview: volume24hValueLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: volume24hLabel.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 10)
            ]}
        
        containerView.add(subview: low24hLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: volume24hValueLabel.bottomAnchor, constant: 10),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 10)
            ]}
        
        containerView.add(subview: low24hValueLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: low24hLabel.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 10)
            ]}
        
        containerView.add(subview: circSupplyLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: containerTopView.bottomAnchor, constant: 10),
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor, constant: 50)
            ]}
        
        containerView.add(subview: circSupplyValueLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: circSupplyLabel.bottomAnchor),
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor, constant: 50)
            ]}
        
        containerView.add(subview: high24hLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: circSupplyValueLabel.bottomAnchor, constant: 10),
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor, constant: 50)
            ]}
        
        containerView.add(subview: high24hValueLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: high24hLabel.bottomAnchor),
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor, constant: 50)
            ]}

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
