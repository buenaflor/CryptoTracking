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
    private var coinSymbol: String?
    
    var coinData: ExchangeDataClass?
    
    func loadData(force: Bool) {
        guard let coinSymbol = coinSymbol else {
            showAlert(title: "Error", message: "Coin ID is incorrect")
            return
        }
        
        SessionManager.ccShared.start(call: CCClient.GetCoinData(tag: "top/exchanges/full", query: ["fsym": coinSymbol, "tsym": "USD"])) { (result) in
            result.onSuccess { value in
                self.coinData = value.data
                self.headerView.configureWithModel(value.data)
                self.activityIndicator.stopAnimating()
                self.title = value.data.coinInfo.fullName
                self.navigationItem.rightBarButtonItem = self.settingsItem
                }.onError { error in
                    print(error)
            }
        }
    }
    
    lazy var settingsItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: #imageLiteral(resourceName: "cryptoTracking_vertical_dots").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(settingsItemTapped(sender:)))
        return item
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(UICollectionViewCell.self)
        cv.isPagingEnabled = true
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        cv.bounces = false
        return cv
    }()

    lazy var fillView = SettingsFillView()
    
    let headerView: CoinDetailHeaderView = {
        let view = CoinDetailHeaderView()
        return view
    }()
    
    var isSettingOpen = false
    
    init(coinID: String, coinSymbol: String) {
        super.init(nibName: nil, bundle: nil)
        self.coinID = coinID
        self.coinSymbol = coinSymbol
        
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = activityIndicatorItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fillView.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.add(subview: headerView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.405)
            ]}
        
        view.add(subview: collectionView) { (v, p) in [
            v.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Actions
    
    @objc func settingsItemTapped(sender: UIBarButtonItem) {

        if !isSettingOpen {
            isSettingOpen = true
            
            fillView.delegate = self
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


// MARK: - FillView Delegate

extension CoinDetailViewController: SettingsFillViewDelegate {
    
    func clicked(exchangeItem: SettingsItemForView) {
        guard let coinSymbol = coinSymbol else {
            showAlert(title: "Error", message: "Something is wrong with the coin name")
            return
        }
        let exchangeVC = ExchangeViewController(coinSymbol: coinSymbol)
        exchangeVC.loadData(force: true)
        navigationController?.pushViewController(exchangeVC, animated: true)
    }
    
    func clicked(tradingPairItem: SettingsItemForView) {
        
        // ToDo
    }
    
    func clicked(removeCoinItem: SettingsItemForView) {
        // ToDo
    }
}


// MARK: - CollectionView DataSource & Delegate

extension CoinDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(UICollectionViewCell.self, for: indexPath)
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = .red
        }
        else {
            cell.backgroundColor = .blue
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerView.loadPosition(x: scrollView.contentOffset.x)
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
    
    func didSelect(settingsVC: SettingsFillView) {
        settingsVC.delegate?.clicked(exchangeItem: self)
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
    
    func didSelect(settingsVC: SettingsFillView) {
        settingsVC.delegate?.clicked(tradingPairItem: self)
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
    
    func didSelect(settingsVC: SettingsFillView) {
        settingsVC.delegate?.clicked(removeCoinItem: self)
    }
}


protocol SettingsFillViewDelegate: class {
    func clicked(exchangeItem: SettingsItemForView)
    func clicked(tradingPairItem: SettingsItemForView)
    func clicked(removeCoinItem: SettingsItemForView)
}

class SettingsFillView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: SettingsFillViewDelegate?
    
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

