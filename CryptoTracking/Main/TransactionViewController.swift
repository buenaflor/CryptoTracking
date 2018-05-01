//
//  TransactionViewController.swift
//  CryptoTracking
//
//  Created by Giancarlo on 27.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit
import RealmSwift

protocol TransactionsItem {
    var cellType: TransactionCell.Type { get }
    func configure(transactionsVC: TransactionViewController, cell: TransactionCell)
    func didSelect(transactionsVC: TransactionViewController, cell: TransactionCell)
}

struct TransactionSection {
    var title: String?
    var items: [TransactionsItem]
    var footer: String?
}

struct TradingPairItem: TransactionsItem {
    
    var cellType: TransactionCell.Type {
        return TransactionDisclosureCell.self
    }
    
    func configure(transactionsVC: TransactionViewController, cell: TransactionCell) {
        cell.label.text = "Trading Pair"
        cell.addValueLabel()
        cell.valueLabel.text = "Select a trading pair"
    }
    
    func didSelect(transactionsVC: TransactionViewController, cell: TransactionCell) {
        let exchangeCell = transactionsVC.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TransactionDisclosureCell
        if exchangeCell?.valueLabel.text == "Select an exchange" {
            transactionsVC.showAlert(title: "Error", message: "Select an exchange first!")
        }
        else {
            guard let coinSymbol = transactionsVC.coinSymbol else { return }
            let tradingPairVC = TradingPairViewController(exchangeName: (exchangeCell?.valueLabel.text)!, coinSymbol: coinSymbol)
            tradingPairVC.loadData(force: true)
            tradingPairVC.delegate = transactionsVC
            transactionsVC.navigationController?.pushViewController(tradingPairVC, animated: true)
        }
    }
    
}

struct SelectExchangeItem: TransactionsItem {
    
    var cellType: TransactionCell.Type {
        return TransactionDisclosureCell.self
    }
    
    func configure(transactionsVC: TransactionViewController, cell: TransactionCell) {
        cell.label.text = "Exchange"
        cell.addValueLabel()
        
        cell.valueLabel.text = "Select an exchange"
    }
    
    func didSelect(transactionsVC: TransactionViewController, cell: TransactionCell) {
        guard let coinSymbol = transactionsVC.coinSymbol else { return }
        let exchangeVC = ExchangeViewController(coinSymbol: coinSymbol)
        exchangeVC.delegate = transactionsVC
        exchangeVC.loadData(force: true)
        transactionsVC.navigationController?.pushViewController(exchangeVC, animated: true)
    }
}

struct BuyPriceItem: TransactionsItem {
    var cellType: TransactionCell.Type {
        return TransactionCell.self
    }
    
    func configure(transactionsVC: TransactionViewController, cell: TransactionCell) {
        
        cell.valueButton.backgroundColor = .lightGray
        cell.valueButton.setTitle("Per Coin", for: .normal)
        cell.valueButton.addTarget(transactionsVC, action: #selector(transactionsVC.showPricePerPicker), for: .touchUpInside)
        
        cell.add(subview: cell.valueButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.widthAnchor.constraint(equalToConstant: 100),
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor)
            ]}
        
        cell.label.text = "Buy Price in \(Accessible.shared.currentUsedCurrencyCode) (\(Accessible.shared.currentUsedCurrencySymbol))"
        
        cell.addValueTextView()
        cell.valueTextView.text = "0"
    }
    
    func didSelect(transactionsVC: TransactionViewController, cell: TransactionCell) {
        cell.valueTextView.becomeFirstResponder()
        
        if cell.valueTextView.text == "0" {
            cell.valueTextView.text = ""
        }
    }
}

struct AmountBoughtItem: TransactionsItem {
    var cellType: TransactionCell.Type {
        return TransactionCell.self
    }
    
    func configure(transactionsVC: TransactionViewController, cell: TransactionCell) {
        cell.label.text = "Amount Bought"
        
        cell.addValueTextView()
        cell.valueTextView.text = "0"
    }
    
    func didSelect(transactionsVC: TransactionViewController, cell: TransactionCell) {
        cell.valueTextView.becomeFirstResponder()
        
        if cell.valueTextView.text == "0" {
            cell.valueTextView.text = ""
        }
    }
}

// Date Picker
struct DateBought: TransactionsItem {
    var cellType: TransactionCell.Type {
        return TransactionCell.self
    }
    
    func configure(transactionsVC: TransactionViewController, cell: TransactionCell) {
        cell.label.text = "Date & Time"
        
        cell.addValueTextView()
        
        cell.valueTextView.text = "\(Date())"
    }
    
    func didSelect(transactionsVC: TransactionViewController, cell: TransactionCell) {
        transactionsVC.showDatePicker()
    }
    
}

class TransactionCell: TableViewCell, UITextFieldDelegate {
    
    override func addLabel() {
        add(subview: label) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor, constant: -12),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20)
            ]}
    }
    lazy var valueButton = UIButton()
    lazy var valueLabel = UILabel()
    lazy var valueTextView: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        return tf
    }()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
    
    func addValueLabel() {
        valueLabel.font = .cryptoRegularLarge
        add(subview: valueLabel) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor, constant: 10),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20)
            ]}
    }
    
    func addValueTextView() {
        add(subview: valueTextView) { (v, p) in [
            v.topAnchor.constraint(equalTo: label.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 15),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -100),
            v.heightAnchor.constraint(equalToConstant: 30)
            ]}
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureLabel(font: .cryptoLight, numberOfLines: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class TransactionDisclosureCell: TransactionCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class TransactionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedButton = 0
    var selectedIndexPath = IndexPath()
    
    var model = [TransactionSection]()
    
    var coinSymbol: String?
    var coinName: String?
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self)
        tv.tableFooterView = UIView()
        return tv
    }()
    
    lazy var buyButton: UIButton = {
        let btn = UIButton()
        btn.tag = 1
        btn.backgroundColor = #colorLiteral(red: 0.1944887459, green: 0.9029509391, blue: 0.4793502826, alpha: 0.2388589348)
        btn.tintColor = .white
        btn.layer.borderColor = #colorLiteral(red: 0, green: 0.8705270402, blue: 0.3759691011, alpha: 1).cgColor
        btn.layer.borderWidth = 2.5
        btn.layer.cornerRadius = 5
        btn.setTitle("Buy", for: .normal)
        btn.addTarget(self, action: #selector(buyButtonTapped(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var sellButton: UIButton = {
        let btn = UIButton()
        btn.tag = 2
        btn.backgroundColor = .clear
        btn.tintColor = .lightGray
        btn.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        btn.layer.borderWidth = 2.5
        btn.layer.cornerRadius = 5
        btn.setTitle("Sell", for: .normal)
        btn.addTarget(self, action: #selector(sellButtonTapped(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var watchButton: UIButton = {
        let btn = UIButton()
        btn.tag = 3
        btn.backgroundColor = .clear
        btn.tintColor = .lightGray
        btn.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        btn.layer.borderWidth = 2.5
        btn.layer.cornerRadius = 5
        btn.setTitle("Watch", for: .normal)
        btn.addTarget(self, action: #selector(watchButtonTapped(sender:)), for: .touchUpInside)
        return btn
    }()
    
    let footerLabel: Label = {
        let lbl = Label(font: .cryptoRegularLarge, numberOfLines: 1)
        lbl.text = "Add Transaction"
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    let headerView = UIView()
    let footerView = UIView()
    
    @objc func buyButtonTapped(sender: UIButton) {
        selectedButton = sender.tag
        
        sellButton.backgroundColor = .clear
        sellButton.tintColor = .lightGray
        sellButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        
        watchButton.backgroundColor = .clear
        watchButton.tintColor = .lightGray
        watchButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        
        buyButton.backgroundColor = #colorLiteral(red: 0.1944887459, green: 0.9029509391, blue: 0.4793502826, alpha: 0.2388589348)
        buyButton.tintColor = .white
        buyButton.layer.borderColor = #colorLiteral(red: 0, green: 0.8705270402, blue: 0.3759691011, alpha: 1).cgColor
        
        footerView.backgroundColor = #colorLiteral(red: 0, green: 0.8705270402, blue: 0.3759691011, alpha: 1)
    }
    
    @objc func sellButtonTapped(sender: UIButton) {
        selectedButton = sender.tag
        
        buyButton.backgroundColor = .clear
        buyButton.tintColor = .lightGray
        buyButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        
        watchButton.backgroundColor = .clear
        watchButton.tintColor = .lightGray
        watchButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        
        sellButton.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0.24)
        sellButton.tintColor = .white
        sellButton.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1).cgColor
        
        footerView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    }
    
    @objc func watchButtonTapped(sender: UIButton) {
        selectedButton = sender.tag
        
        buyButton.backgroundColor = .clear
        buyButton.tintColor = .lightGray
        buyButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        
        sellButton.backgroundColor = .clear
        sellButton.tintColor = .lightGray
        sellButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        
        watchButton.backgroundColor = #colorLiteral(red: 0.1102050645, green: 0.659310277, blue: 0.9254902005, alpha: 0.24)
        watchButton.tintColor = .white
        watchButton.layer.borderColor = #colorLiteral(red: 0.1734314166, green: 0.7699478535, blue: 0.9000489764, alpha: 1).cgColor
        
        footerView.backgroundColor = #colorLiteral(red: 0.1734314166, green: 0.7699478535, blue: 0.9000489764, alpha: 1)
    }
    
    init(coinSymbol: String, coinName: String) {
        super.init(nibName: nil, bundle: nil)
        self.coinSymbol = coinSymbol
        self.coinName = coinName
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: coinSymbol, style: .plain, target: nil, action: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        title = "Add Transaction"
        
        view.backgroundColor = .white
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        headerView.backgroundColor = .gray
        footerView.backgroundColor = #colorLiteral(red: 0, green: 0.8705270402, blue: 0.3759691011, alpha: 1)
        footerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(footerViewTapped)))
        
        view.add(subview: headerView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalToConstant: 100)
            ]}
        
        headerView.add(subview: buyButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 10),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.30),
            v.heightAnchor.constraint(equalToConstant: 60)
            ]}
        
        headerView.add(subview: sellButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 20),
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.30),
            v.heightAnchor.constraint(equalToConstant: 60)
            ]}
        
        headerView.add(subview: watchButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 20),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -10),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.30),
            v.heightAnchor.constraint(equalToConstant: 60)
            ]}
        
        footerView.frame = CGRect(x: view.center.x, y: view.frame.height - 70, width: view.frame.width, height: 70)
        footerView.center.x = view.center.x
        view.addSubview(footerView)
        
        footerView.add(subview: footerLabel) { (v, p) in [
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor)
            ]}
        
        view.add(subview: tableView) { (v, p) in [
            v.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: footerView.topAnchor)
            ]}
        
        updateView()
    }
    
    func updateView() {
        let generalSection = TransactionSection(title: "General", items: [ SelectExchangeItem(), TradingPairItem(), BuyPriceItem(), AmountBoughtItem(), DateBought() ], footer: nil)
        
        model = [ generalSection ]
        
        for section in model {
            for item in section.items {
                tableView.register(item.cellType, forCellReuseIdentifier: item.cellType.defaultReuseIdentifier)
            }
        }
        
        tableView.reloadData()
    }
    
    @objc func footerViewTapped() {
        let realm = try! Realm()
        let coins = realm.objects(Coin.self)
        
        guard let exchangeCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TransactionDisclosureCell,
        let tradingPairCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? TransactionDisclosureCell,
        let buyPriceCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? TransactionCell,
        let amountBoughtCell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? TransactionCell,
        let dateCell = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? TransactionCell,
        let coinName = coinName, let coinSymbol = coinSymbol
            else { return }

        let exchange = exchangeCell.valueLabel.text!
        let tradingPair = tradingPairCell.valueLabel.text!
        let buyPrice = buyPriceCell.valueTextView.text!
        let amountBought = amountBoughtCell.valueTextView.text!
        let date = dateCell.valueTextView.text!

        let transaction = Transaction()
        transaction.exchangeName = exchange
        transaction.tradingPair = tradingPair
        transaction.date = date
        transaction.transactionType = 0

        // Risky
        transaction.price = Double(buyPrice)!
        transaction.amount = Double(amountBought)!

        coins.forEach { (coin) in
            if coin.symbol == coinSymbol && coinName == coinName {
                
            }
        }
        
        let coin = Coin()
        coin.name = coinName
        coin.symbol = coinSymbol
        coin.transactions.append(transaction)
        
        if !coins.contains(coin) {
            try! realm.write {
                realm.add(coin)
                print("added")
            }
        }
        else {
            
            let filteredCoins = coins.filter { (coin) -> Bool in
                if coin.name == coinName && coin.symbol == coinSymbol {
                    return true
                }
                else {
                    return false
                }
            }
            guard let theCoin = filteredCoins.first else { return }
            
            try! realm.write {
                theCoin.transactions.append(transaction)
                print("adding transaction succeeded")
            }
        }
        
        navigationController?.popToRootViewController(animated: true)
    }


// Test Phase
@objc func keyboardWillShow(notification: NSNotification) {
}

@objc func keyboardWillHide(notification: NSNotification) {
    
}

// Only relates to Buy Price Item
@objc func showPricePerPicker() {
        let alertController = UIAlertController(title: "Buy Price", message: nil, preferredStyle: .actionSheet)

        
        alertController.addAction(UIAlertAction(title: "Per Coin", style: .default, handler: { (action) in
            let cell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? TransactionCell
            cell?.valueButton.setTitle("Per Coin", for: .normal)
        }))
        
        alertController.addAction(UIAlertAction(title: "In Total", style: .default, handler: { (action) in
            let cell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? TransactionCell
            cell?.valueButton.setTitle("In Total", for: .normal)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showDatePicker() {
        let datePickerController = DatePickerController()
        datePickerController.modalPresentationStyle = .popover
        datePickerController.preferredContentSize = CGSize(width: 300, height: 300)
        datePickerController.delegate = self
        
        let centerView = UIView(frame: CGRect(x: view.center.x, y: view.center.y + 70, width: 10, height: 10))
        view.addSubview(centerView)
        
        let popoverPresentationController = datePickerController.popoverPresentationController
        popoverPresentationController?.delegate = self
        popoverPresentationController?.permittedArrowDirections = .unknown
        popoverPresentationController?.sourceView = centerView
        
        present(datePickerController, animated: true, completion: nil)
    }

    func itemAt(indexPath: IndexPath) -> TransactionsItem {
        return model[indexPath.section].items[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 73
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemAt(indexPath: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: item.cellType.defaultReuseIdentifier, for: indexPath) as? TransactionCell else {
            return UITableViewCell()
        }
        
        item.configure(transactionsVC: self, cell: cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow()
        
        guard let cell = tableView.cellForRow(at: indexPath) as? TransactionCell else { return }
        
        itemAt(indexPath: indexPath).didSelect(transactionsVC: self, cell: cell)
    }
}

extension TransactionViewController: UIPopoverPresentationControllerDelegate, DatePickerControllerDelegate, ExchangeViewControllerDelegate, TradingPairViewControllerDelegate {
    
    // TradingPair Delegate
    
    func tradingPairViewController(_ tradingPairViewController: TradingPairViewController, didPick tradingPair: String) {
        let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? TransactionDisclosureCell
        cell?.valueLabel.text = tradingPair
    }
    
    
    // ExchangeView Delegate
    
    func exchangeViewController(_ exchangeViewController: ExchangeViewController, didPick exchange: Exchange) {
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TransactionDisclosureCell
        cell?.valueLabel.text = exchange.market
    }
    
    
    // DatePicker Delegate
    
    func datePickerDidPick(_ datePickerController: DatePickerController) {
        let cell = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? TransactionCell
        cell?.valueTextView.text = "\(datePickerController.datePicker.date)"
    }
    
    
     // Popover Delegate
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        print("hey")
    }
}
