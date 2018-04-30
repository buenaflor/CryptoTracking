//
//  MainViewController.swift
//  CryptoTracking
//
//  Created by Giancarlo on 24.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class MainViewController: MainController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.add(subview: mainHeaderView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.16)
            ]}
        
        view.add(subview: tableView) { (v, p) in [
            v.topAnchor.constraint(equalTo: mainHeaderView.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor)
            ]}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateView()
    }
    
    private func updateView() {
        
        if !activityIndicatorAdded() {
            // Set it here too or it will dissappear
            navigationItem.leftBarButtonItem = titleItem
        }
        navigationItem.rightBarButtonItems = [ settingsItem, searchItem ]
        mainHeaderView.loadData(force: true)
        tableView.reloadData()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == self.finalCoinData.count ? 120 : 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // Add +1 for the last cell (add coin)
        return finalCoinData.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == finalCoinData.count {
            let cell = tableView.dequeueReusableCell(MainAddCoinCell.self, for: indexPath)
            cell.configureLabel(font: .cryptoRegularLarge, numberOfLines: 1)
            cell.label.text = "Add Coin"
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(MainCoinTickerCell.self, for: indexPath)
            let coin = self.finalCoinData[indexPath.row]
            cell.configureWithModel(coin)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow()
       
        if indexPath.row != self.finalCoinData.count {
            let coinVC = CoinDetailViewController(finalCoinData: finalCoinData[indexPath.row])
            coinVC.loadData(force: true)
            navigationController?.pushViewController(coinVC, animated: true)
        }
        else {

        }
    }
}

extension MainViewController: ClickableDelegate {
    
    func clicked(button: UIButton) {
        let vc = CryptoSearchViewController()
        vc.loadData(force: true)
        present(vc.wrapped(), animated: true, completion: nil)
    }
    
    
}


