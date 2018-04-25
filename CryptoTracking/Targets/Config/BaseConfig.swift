//
//  BaseConfig.swift
//  CryptoTracking
//
//  Created by Giancarlo on 24.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Foundation

class BaseConfig {
    static let shared = BaseConfig()
    
    var cmcBaseURL: URL {
        return URL(string: "https://api.coinmarketcap.com/v1/")!
    }
    
    var ccBaseURL: URL {
        return URL(string: "https://www.cryptocompare.com/api/data/")!
    }
}

extension SessionManager {
    static let shared = SessionManager()  
}
