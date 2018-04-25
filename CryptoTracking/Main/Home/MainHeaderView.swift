//
//  MainHeaderView.swift
//  CryptoTracking
//
//  Created by Giancarlo on 24.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

protocol MainHeaderViewDelegate: class {
    func mainHeaderView(_ mainHeaderView: MainHeaderView, didClick sortedCoin: CoinTicker)
    func mainHeaderView(_ mainHeaderView: MainHeaderView, didClick sortedHolding: String)
    func mainHeaderView(_ mainHeaderView: MainHeaderView, didClick sortedPrice: Int)
    func mainHeaderView(_ mainHeaderView: MainHeaderView, didClick totalHolding: Double)
    func mainHeaderView(_ mainHeaderView: MainHeaderView, didClick percentage: Float)
}

class MainHeaderView: BaseView {
    
    override func loadData(force: Bool) {
        print("loaded")
    }
    
    
}
