//
//  Model.swift
//  CryptoTracking
//
//  Created by Giancarlo on 30.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import RealmSwift

enum TransactionType: Int {
    case buy = 0
    case sell = 1
}

class Coin: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var symbol = ""
    var transactions = List<Transaction>()
}

class Transaction: Object {
    @objc dynamic var exchangeName = ""
    @objc dynamic var date = ""
    @objc dynamic var tradingPair = ""
    @objc dynamic var transactionType = TransactionType.buy.rawValue
    @objc dynamic var price = 0.0
    @objc dynamic var cost = 0.0
    @objc dynamic var amount = 0.0
}

