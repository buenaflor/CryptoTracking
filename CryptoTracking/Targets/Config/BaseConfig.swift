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
        return URL(string: "https://min-api.cryptocompare.com/data/")!
    }

    var ccMediaBaseURL: URL {
        return URL(string: "www.cryptocompare.com")!
    }
}

extension SessionManager {
    static let ccShared = SessionManager(clientType: ClientType.ccClient)
    static let cmcShared = SessionManager(clientType: ClientType.cmcClient)
}
