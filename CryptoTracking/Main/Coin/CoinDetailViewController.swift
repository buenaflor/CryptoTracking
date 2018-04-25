//
//  CoinDetailViewController.swift
//  CryptoTracking
//
//  Created by Giancarlo on 25.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class CoinDetailViewController: BaseViewController, LoadingController {
    
    // Unused
    func changed() { }
    
    
    private var coinID: String?
    
    func loadData(force: Bool) {
        guard let coinID = coinID else {
            showAlert(title: "Error", message: "Coin ID is incorrect")
            return
        }
        SessionManager.shared.start(call: CMCClient.GetSpecCurrencyTicker(tag: "ticker/\(coinID)/")) { (result) in
            result.onSuccess { value in
                if value.items.count == 1 {
                    value.items.forEach({
                        self.title = $0.name
                    })
                    self.activityIndicator.stopAnimating()
                    self.navigationItem.rightBarButtonItem = self.settingsItem
                }
                else {
                    self.showAlert(title: "Error", message: "An error has occured")
                }
                
                }.onError { error in
                    print(error.localizedDescription)
            }
        }
    }
    
    lazy var settingsItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: #imageLiteral(resourceName: "cryptoTracking_vertical_dots").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(settingsItemTapped(sender:)))
        return item
    }()
    
    var isSettingOpen = false
    
    init(coinID: String) {
        super.init(nibName: nil, bundle: nil)
        self.coinID = coinID
        
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = activityIndicatorItem
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Actions
    
    @objc func settingsItemTapped(sender: UIBarButtonItem) {

        if !isSettingOpen {
            isSettingOpen = true
            
            let fillView = SettingsFillView()
            fillView.tag = 1
            fillView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
            // Hacky solution
            let tapView = UIView()
            tapView.backgroundColor = .clear
            tapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(settingsItemTapped(sender:))))
            fillView.add(subview: tapView) { (v, p) in [
                v.bottomAnchor.constraint(equalTo: p.bottomAnchor),
                v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
                v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
                v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.6)
                ]}
            
            view.fillToSuperview(fillView)
        }
        else {
            isSettingOpen = false
            
            if let fillView = view.viewWithTag(1) {
                fillView.removeFromSuperview()
            }
        }
    }
}

// MARK: - Custom SettingsCell

class SettingsCellForView: UITableViewCell {
    
    let customImageView = UIImageView()
    let label = Label(font: .cryptoRegularLarge, numberOfLines: 1)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        add(subview: customImageView) { (v, p) in [
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20),
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.heightAnchor.constraint(equalToConstant: 20),
            v.widthAnchor.constraint(equalToConstant: 20)
            ]}
        
        add(subview: self.label) { (v, p) in [
            v.leadingAnchor.constraint(equalTo: customImageView.trailingAnchor, constant: 40),
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DisclosureCellForView: SettingsCellForView {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Custom Settings Items

struct ExchangeItem: SettingsItemForView {
    
    var cellType: SettingsCellForView.Type {
        return DisclosureCellForView.self
    }
    
    func configure(cell: SettingsCellForView) {
        cell.imageView?.image = #imageLiteral(resourceName: "cryptoTracking_triangle").withRenderingMode(.alwaysTemplate)
        cell.label.text = "Exchange"
    }
    
    func didSelect(settingsVC: UIView) {
        print("clicked")
    }
}

struct TradingPair: SettingsItemForView {
    
    var cellType: SettingsCellForView.Type {
        return DisclosureCellForView.self
    }
    
    func configure(cell: SettingsCellForView) {
        cell.imageView?.image = #imageLiteral(resourceName: "cryptoTracking_trading_pair").withRenderingMode(.alwaysTemplate)
        cell.label.text = "Trading Pair"
    }
    
    func didSelect(settingsVC: UIView) {
        print("clicked")
    }
}

struct RemoveCoin: SettingsItemForView {
    
    var cellType: SettingsCellForView.Type {
        return SettingsCellForView.self
    }
    
    func configure(cell: SettingsCellForView) {
        cell.imageView?.image = #imageLiteral(resourceName: "cryptoTracking_delete").withRenderingMode(.alwaysTemplate)
        cell.label.text = "Remove from Portfolio"
    }
    
    func didSelect(settingsVC: UIView) {
        print("clicked")
    }
}


class SettingsFillView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var model = [SettingsSectionForView]()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .white
        tv.bounces = false
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        add(subview: tableView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.4)
            ]}
        
        bringSubview(toFront: tableView)
    
        updateView()
    }
    
    func updateView() {
        let generalSection = SettingsSectionForView(title: "Coin Settings", items: [ ExchangeItem(), TradingPair(), RemoveCoin() ], footer: nil)
        
        model = [ generalSection ]
        
        for section in model {
            for item in section.items {
                tableView.register(item.cellType, forCellReuseIdentifier: item.cellType.defaultReuseIdentifier)
            }
        }
        
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func itemAt(indexPath: IndexPath) -> SettingsItemForView {
        return model[indexPath.section].items[indexPath.row]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemAt(indexPath: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: item.cellType.defaultReuseIdentifier, for: indexPath) as? SettingsCellForView else {
            return UITableViewCell()
        }
        
        item.configure(cell: cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow()
        
        itemAt(indexPath: indexPath).didSelect(settingsVC: self)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model[section].title
    }
}

