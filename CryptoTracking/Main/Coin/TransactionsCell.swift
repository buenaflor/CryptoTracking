//
//  TransactionsCell.swift
//  CryptoTracking
//
//  Created by Giancarlo on 02.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class TransactionHeaderView: BaseView {
    override func loadData(force: Bool) {

    }

    let avgBuyLabel = Label(font: .cryptoMedium, numberOfLines: 1)
    let avgSellLabel = Label(font: .cryptoMedium, numberOfLines: 1)

    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [avgSellLabel, avgBuyLabel])
        return sv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TransactionsCVWindow: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, Configurable {
    
    var model: FinalCoinData?
    
    func configureWithModel(_ finalCoinData: FinalCoinData) {
        self.model = finalCoinData
    }
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = #colorLiteral(red: 0.9044284326, green: 0.9044284326, blue: 0.9044284326, alpha: 1)
        tv.delegate = self
        tv.dataSource = self
        tv.register(TransactionsCVCell.self)
        tv.register(FirstTransactionsCVCell.self)
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        fillToSuperview(tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(FirstTransactionsCVCell.self, for: indexPath)
        guard let finalCoinData = model else { return cell }
        cell.backgroundColor = #colorLiteral(red: 0.9044284326, green: 0.9044284326, blue: 0.9044284326, alpha: 1)
        cell.configureWithModel(finalCoinData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
}

class TransactionsCVCell: UITableViewCell, Configurable {
    var model: FinalCoinData?
    
    func configureWithModel(_ finalCoinData: FinalCoinData) {
        self.model = finalCoinData
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FirstTransactionsCVCell: UITableViewCell, Configurable {
    
    var model: FinalCoinData?
    
    func configureWithModel(_ finalCoinData: FinalCoinData) {
        self.model = finalCoinData
        
        buyPriceLabel.text = "\(finalCoinData.data.coinInfo.name) Buy Price"
        costLabel.text = "Cost (incl. fee)"
        tradingPairLabel.text = "Trading Pair"
        worthLabel.text = "Worth"
        amountLabel.text = "Amount Bought"
        percentageLabel.text = "Win/Lose"
        
        let buyPrice = finalCoinData.coin.transactions[0].price
        let tradingPair = finalCoinData.coin.transactions[0].tradingPair
        let amountBought = finalCoinData.coin.transactions[0].amount
        let cost = buyPrice * amountBought
        let worth = amountBought * finalCoinData.data.aggregatedData.price
        let percentage = (((worth / cost) - 1) * 100).roundToTwoDigits()
        
        buyPriceValueLabel.text = "\(buyPrice)"
        tradingPairValueLabel.text = "\(tradingPair)"
        amountValueLabel.text = "\(amountBought)"
        costValueLabel.text = "\(cost)"
        worthValueLabel.text = "\(worth)"
        percentageValueLabel.text = "\(percentage)"
        
        // index is always 0 - first transaction
    }
    
    let buyPriceLabel = Label(font: .cryptoRegular, numberOfLines: 1)
    let costLabel = Label(font: .cryptoRegular, numberOfLines: 1)
    let tradingPairLabel = Label(font: .cryptoRegular, numberOfLines: 1)
    let worthLabel = Label(font: .cryptoRegular, numberOfLines: 1)
    let amountLabel = Label(font: .cryptoRegular, numberOfLines: 1)
    let percentageLabel = Label(font: .cryptoRegular, numberOfLines: 1)
    
    let buyPriceValueLabel = Label(font: .cryptoMedium, numberOfLines: 1)
    let costValueLabel = Label(font: .cryptoMedium, numberOfLines: 1)
    let tradingPairValueLabel = Label(font: .cryptoMedium, numberOfLines: 1)
    let worthValueLabel = Label(font: .cryptoMedium, numberOfLines: 1)
    let amountValueLabel = Label(font: .cryptoMedium, numberOfLines: 1)
    let percentageValueLabel = Label(font: .cryptoMedium, numberOfLines: 1)
    
    lazy var firstRowLabelStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [buyPriceLabel, tradingPairLabel, amountLabel])
        sv.distribution = .equalSpacing
        return sv
    }()
    
    lazy var firstRowValueStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [buyPriceLabel, tradingPairLabel, amountLabel])
        sv.distribution = .equalSpacing
        return sv
    }()
    
    lazy var secondRowLabelStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [costLabel, worthLabel, percentageLabel])
        sv.distribution = .equalSpacing
        return sv
    }()
    
    lazy var secondRowValueStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [costValueLabel, worthValueLabel, percentageValueLabel])
        sv.distribution = .equalSpacing
        return sv
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 5
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        add(subview: containerView) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor, constant: 10),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -20),
            v.heightAnchor.constraint(equalToConstant: 120)
            ]}
        
        containerView.add(subview: firstRowLabelStackView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 10),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -20),
            v.heightAnchor.constraint(equalToConstant: 20)
            ]}
        
        containerView.add(subview: firstRowValueStackView) { (v, p) in [
            v.topAnchor.constraint(equalTo: firstRowLabelStackView.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -20),
            v.heightAnchor.constraint(equalToConstant: 20)
            ]}

        containerView.add(subview: secondRowLabelStackView) { (v, p) in [
            v.topAnchor.constraint(equalTo: firstRowValueStackView.topAnchor, constant: 30),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -20),
            v.heightAnchor.constraint(equalToConstant: 20)
            ]}

        containerView.add(subview: secondRowValueStackView) { (v, p) in [
            v.topAnchor.constraint(equalTo: secondRowLabelStackView.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -20),
            v.heightAnchor.constraint(equalToConstant: 20)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
