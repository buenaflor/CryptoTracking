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
        tv.register(AddTransactionCell.self)
        tv.allowsSelection = false
        tv.separatorStyle = .none
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableViewReceived(notification:)), name: .reloadTableView, object: nil)
        fillToSuperview(tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func reloadTableViewReceived(notification: Notification) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let finalCoinData = model else { return 0 }
        return finalCoinData.coin.transactions.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let finalCoinData = model else { return UITableViewCell() }
        
        print(finalCoinData.coin.transactions.count)
        switch indexPath.row {
        case finalCoinData.coin.transactions.count:
            let cell = tableView.dequeueReusableCell(FirstTransactionsCVCell.self, for: indexPath)
            cell.backgroundColor = #colorLiteral(red: 0.9044284326, green: 0.9044284326, blue: 0.9044284326, alpha: 1)
            cell.tag = indexPath.row
            cell.configureWithModel(finalCoinData)
            print(indexPath.row)
            return cell
        case 0:
            let cell = tableView.dequeueReusableCell(AddTransactionCell.self, for: indexPath)
            cell.backgroundColor = #colorLiteral(red: 0.9044284326, green: 0.9044284326, blue: 0.9044284326, alpha: 1)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(TransactionsCVCell.self, for: indexPath)
            cell.backgroundColor = #colorLiteral(red: 0.9044284326, green: 0.9044284326, blue: 0.9044284326, alpha: 1)
            cell.tag = indexPath.row - 1
            print(indexPath.row)
            cell.configureWithModel(finalCoinData)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 100 : 220
    }
}

class TransactionsCVCell: UITableViewCell, Configurable {
    var model: FinalCoinData?
    
    func configureWithModel(_ finalCoinData: FinalCoinData) {
        self.model = finalCoinData
        
        buyPriceLabel.text = "\(finalCoinData.data.coinInfo.name) Buy Price"
        costLabel.text = "Cost (incl. fee)"
        tradingPairLabel.text = "Trading Pair"
        worthLabel.text = "Worth"
        amountLabel.text = "Amount Bought"
        percentageLabel.text = "Win/Lose"
        
        let coin = finalCoinData.coin
        
        let transactions = coin.transactions.reversed()
        let transaction = transactions[transactions.index(transactions.startIndex, offsetBy: tag)]
        let aggregatedData = finalCoinData.data.aggregatedData
        
        let buyPrice = transaction.price
        let tradingPair = transaction.tradingPair
        let amountBought = transaction.amount
        let cost = buyPrice * amountBought
        let worth = amountBought * aggregatedData.price
        let percentage = (((worth / cost) - 1) * 100).roundToTwoDigits()
        let date = transaction.date
        let exchange = transaction.exchangeName
        
        if transaction.transactionType == 0 {
            actionImageView.image = #imageLiteral(resourceName: "cryptoTracking_circled_b").withRenderingMode(.alwaysTemplate)
            actionImageView.tintColor = #colorLiteral(red: 0, green: 0.8705270402, blue: 0.3759691011, alpha: 1)
        }
        
        buyPriceValueLabel.text = "\(buyPrice)"
        tradingPairValueLabel.text = "\(tradingPair)"
        amountValueLabel.text = "\(amountBought)"
        costValueLabel.text = "\(cost)"
        worthValueLabel.text = "\(worth)"
        percentageValueLabel.text = "\(percentage)"
        dateLabel.text = "\(date) via \(exchange)"
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
    
    let templateView1 = UIView()
    let templateView2 = UIView()
    
    let dateLabel = Label(font: .cryptoMedium, numberOfLines: 1)
    
    let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let borderView2: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let borderView3: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let actionImageView = UIImageView()
    
    lazy var firstRowLabelStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [buyPriceLabel, tradingPairLabel, amountLabel])
        sv.distribution = .equalCentering
        return sv
    }()
    
    lazy var firstRowValueStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [buyPriceValueLabel, tradingPairValueLabel, amountValueLabel])
        sv.distribution = .equalCentering
        return sv
    }()
    
    lazy var secondRowLabelStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [costLabel, worthLabel, percentageLabel])
        sv.distribution = .equalCentering
        return sv
    }()
    
    lazy var secondRowValueStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [costValueLabel, worthValueLabel, percentageValueLabel])
        sv.distribution = .equalCentering
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
        
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(containerViewTapped)))
        
        add(subview: containerView) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor, constant: -30),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -20),
            v.heightAnchor.constraint(equalToConstant: 110)
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
        
        add(subview: templateView1) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.topAnchor.constraint(equalTo: containerView.bottomAnchor)
            ]}
        
        add(subview: borderView) { (v, p) in [
            v.topAnchor.constraint(equalTo: templateView1.topAnchor),
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: templateView1.leadingAnchor),
            v.widthAnchor.constraint(equalToConstant: 0.65)
            ]}
        
        
        add(subview: templateView2) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: containerView.topAnchor),
            v.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalToConstant: 22)
            ]}
        
        add(subview: borderView2) { (v, p) in [
            v.topAnchor.constraint(equalTo: templateView2.topAnchor),
            v.bottomAnchor.constraint(equalTo: containerView.topAnchor),
            v.leadingAnchor.constraint(equalTo: templateView2.leadingAnchor),
            v.widthAnchor.constraint(equalToConstant: 0.65)
            ]}
        
        add(subview: actionImageView) { (v, p) in [
            v.leadingAnchor.constraint(equalTo: templateView2.leadingAnchor, constant: -20),
            v.bottomAnchor.constraint(equalTo: borderView2.topAnchor),
            v.heightAnchor.constraint(equalToConstant: 40),
            v.widthAnchor.constraint(equalToConstant: 40)
            ]}
        
        add(subview: borderView3) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor),
            v.bottomAnchor.constraint(equalTo: actionImageView.topAnchor),
            v.leadingAnchor.constraint(equalTo: templateView2.leadingAnchor),
            v.widthAnchor.constraint(equalToConstant: 0.65)
            ]}

        add(subview: dateLabel) { (v, p) in [
            v.leadingAnchor.constraint(equalTo: actionImageView.trailingAnchor, constant: 10),
            v.bottomAnchor.constraint(equalTo: actionImageView.bottomAnchor, constant: -11)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func containerViewTapped() {
        guard let coin = model?.coin else { return }
        let transactions = coin.transactions.reversed()
        let transaction = transactions[transactions.index(transactions.startIndex, offsetBy: tag)]
        NotificationCenter.default.post(name: .clicked, object: transaction)
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
        
        let coin = finalCoinData.coin
        
        // index is always last - first transaction
        let transactions = coin.transactions.reversed()
        guard let transaction = transactions.last else { return }
        
        let aggregatedData = finalCoinData.data.aggregatedData
        let buyPrice = transaction.price
        let tradingPair = transaction.tradingPair
        let amountBought = transaction.amount
        let cost = buyPrice * amountBought
        let worth = amountBought * aggregatedData.price
        let percentage = (((worth / cost) - 1) * 100).roundToTwoDigits()
        let date = transaction.date
        let exchange = transaction.exchangeName
        
        if transaction.transactionType == 0 {
            actionImageView.image = #imageLiteral(resourceName: "cryptoTracking_circled_b").withRenderingMode(.alwaysTemplate)
            actionImageView.tintColor = #colorLiteral(red: 0, green: 0.8705270402, blue: 0.3759691011, alpha: 1)
        }
        
        buyPriceValueLabel.text = "\(buyPrice)"
        tradingPairValueLabel.text = "\(tradingPair)"
        amountValueLabel.text = "\(amountBought)"
        costValueLabel.text = "\(cost)"
        worthValueLabel.text = "\(worth)"
        percentageValueLabel.text = "\(percentage)"
        dateLabel.text = "\(date) via \(exchange)"
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
    
    let templateView1 = UIView()
    
    let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let borderView2: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let dateLabel = Label(font: .cryptoMedium, numberOfLines: 1)
    
    let actionImageView = UIImageView()
    
    lazy var firstRowLabelStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [buyPriceLabel, tradingPairLabel, amountLabel])
        sv.distribution = .equalCentering
        return sv
    }()
    
    lazy var firstRowValueStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [buyPriceValueLabel, tradingPairValueLabel, amountValueLabel])
        sv.distribution = .equalCentering
        return sv
    }()
    
    lazy var secondRowLabelStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [costLabel, worthLabel, percentageLabel])
        sv.distribution = .equalCentering
        return sv
    }()
    
    lazy var secondRowValueStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [costValueLabel, worthValueLabel, percentageValueLabel])
        sv.distribution = .equalCentering
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
        
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(containerViewTapped)))
        
        add(subview: containerView) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor, constant: 10),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -20),
            v.heightAnchor.constraint(equalToConstant: 110)
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
        
        add(subview: templateView1) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: containerView.topAnchor),
            v.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalToConstant: 22)
            ]}
        
        add(subview: borderView) { (v, p) in [
            v.topAnchor.constraint(equalTo: templateView1.topAnchor),
            v.bottomAnchor.constraint(equalTo: containerView.topAnchor),
            v.leadingAnchor.constraint(equalTo: templateView1.leadingAnchor),
            v.widthAnchor.constraint(equalToConstant: 0.65)
            ]}
        
        add(subview: actionImageView) { (v, p) in [
            v.leadingAnchor.constraint(equalTo: templateView1.leadingAnchor, constant: -20),
            v.bottomAnchor.constraint(equalTo: borderView.topAnchor),
            v.heightAnchor.constraint(equalToConstant: 40),
            v.widthAnchor.constraint(equalToConstant: 40)
            ]}
        
        add(subview: dateLabel) { (v, p) in [
            v.leadingAnchor.constraint(equalTo: actionImageView.trailingAnchor, constant: 10),
            v.bottomAnchor.constraint(equalTo: actionImageView.bottomAnchor, constant: -11)
            ]}
        
        add(subview: borderView2) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor),
            v.bottomAnchor.constraint(equalTo: actionImageView.topAnchor),
            v.leadingAnchor.constraint(equalTo: templateView1.leadingAnchor),
            v.widthAnchor.constraint(equalToConstant: 0.65)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func containerViewTapped() {
        guard let coin = model?.coin else { return }
        let transactions = coin.transactions.reversed()
        let transaction = transactions.last
        NotificationCenter.default.post(name: .clicked, object: transaction)
    }
}

class AddTransactionCell: UITableViewCell{
    
    let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let borderView2: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let templateView1 = UIView()
    
    let actionImageView = UIImageView()
    let outerImageView = UIImageView()
    
    let addTransactionButton = UIButton()
    
    let newLabel = Label(font: .cryptoBoldLarge, numberOfLines: 1)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addTransactionButton.setImage(#imageLiteral(resourceName: "cryptoTracking_plus").withRenderingMode(.alwaysTemplate), for: .normal)
        addTransactionButton.tintColor = #colorLiteral(red: 0.1734314166, green: 0.7699478535, blue: 0.9000489764, alpha: 1)
        addTransactionButton.addTarget(self, action: #selector(addTransactionButtonTapped(sender:)), for: .touchUpInside)
        
        outerImageView.image = #imageLiteral(resourceName: "cryptoTracking_circle_outline").withRenderingMode(.alwaysTemplate)
        outerImageView.tintColor = #colorLiteral(red: 0.1734314166, green: 0.7699478535, blue: 0.9000489764, alpha: 1)
        outerImageView.layer.opacity = 0.35
        
        newLabel.text = "Add new transaction"
        newLabel.textColor = #colorLiteral(red: 0.1734314166, green: 0.7699478535, blue: 0.9000489764, alpha: 1)
        
        add(subview: addTransactionButton) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 15),
            v.widthAnchor.constraint(equalToConstant: 40),
            v.heightAnchor.constraint(equalToConstant: 40)
            ]}
        
        add(subview: outerImageView) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 10.9),
            v.widthAnchor.constraint(equalToConstant: 48),
            v.heightAnchor.constraint(equalToConstant: 48)
            ]}
        
        add(subview: templateView1) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 35),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.topAnchor.constraint(equalTo: addTransactionButton.bottomAnchor)
            ]}
        
        add(subview: borderView) { (v, p) in [
            v.topAnchor.constraint(equalTo: addTransactionButton.bottomAnchor),
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: templateView1.leadingAnchor),
            v.widthAnchor.constraint(equalToConstant: 0.65)
            ]}
    
        add(subview: newLabel) { (v, p) in [
            v.leadingAnchor.constraint(equalTo: outerImageView.trailingAnchor, constant: 15),
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addTransactionButtonTapped(sender: UIButton) {
        NotificationCenter.default.post(name: .clicked, object: nil)
    }
}
