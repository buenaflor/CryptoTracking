//
//  Foundation.swift
//  CryptoTracking
//
//  Created by Giancarlo on 01.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Foundation

extension Double {
    func roundToTwoDigits() -> Double {
        return (self * 1000).rounded() / 1000
    }
}

extension Notification.Name {
    static let changePercentages = Notification.Name(
        rawValue: "changePercentages")
    static let reloadTableView = Notification.Name(
        rawValue: "reloadTableView")
}
