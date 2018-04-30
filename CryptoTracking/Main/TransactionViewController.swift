//
//  TransactionViewController.swift
//  CryptoTracking
//
//  Created by Giancarlo on 27.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

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
        let exchangeVC = ExchangeViewController(coinSymbol: transactionsVC.coinSymbol)
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
        cell.valueTextView.keyboardType = .numberPad
        
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
        cell.valueTextView.keyboardType = .decimalPad
    }
    
    func didSelect(transactionsVC: TransactionViewController, cell: TransactionCell) {
        cell.valueTextView.becomeFirstResponder()
        cell.valueTextView.keyboardType = .numberPad
        
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

class TransactionCell: TableViewCell {
    
    override func addLabel() {
        add(subview: label) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor, constant: -12),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20)
            ]}
    }
    lazy var valueButton = UIButton()
    lazy var valueLabel = UILabel()
    lazy var valueTextView = TextView(isEditable: true, font: .cryptoRegularLarge)
    
    func addValueLabel() {
        valueLabel.font = .cryptoRegularLarge
        add(subview: valueLabel) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor, constant: 10),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20)
            ]}
    }
    
    func addValueTextView() {
        valueTextView.addDoneCancelToolbar()
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
    
    var selectedIndexPath = IndexPath()
    
    var model = [TransactionSection]()
    
    var coinSymbol = ""
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self)
        return tv
    }()
    
    init(coinSymbol: String) {
        super.init(nibName: nil, bundle: nil)
        self.coinSymbol = coinSymbol
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        title = "Add Transaction"
        
        view.backgroundColor = .white
        view.fillToSuperview(tableView)
        
        updateView()
    }
    
    func updateView() {
        let generalSection = TransactionSection(title: "General", items: [ TradingPairItem(), SelectExchangeItem(), BuyPriceItem(), AmountBoughtItem(), DateBought() ], footer: nil)
        
        model = [ generalSection ]
        
        for section in model {
            for item in section.items {
                tableView.register(item.cellType, forCellReuseIdentifier: item.cellType.defaultReuseIdentifier)
            }
        }
        
        tableView.reloadData()
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

extension TransactionViewController: UIPopoverPresentationControllerDelegate, DatePickerControllerDelegate, ExchangeViewControllerDelegate {
    
    // ExchangeView Delegate
    
    func exchangeViewController(_ exchangeViewController: ExchangeViewController, didPick exchange: Exchange) {
        
        let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? TransactionDisclosureCell
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
