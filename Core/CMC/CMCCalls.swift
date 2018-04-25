//
//  CMCCalls.swift
//  CryptoTracking
//
//  Created by Giancarlo on 24.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Endpoints

extension CMCClient {
    struct GetSpecCurrencyTicker: Call {
        typealias ResponseType = CoinTickerResponse
        
        var tag: String
        
        var request: URLRequestEncodable {
            return Request(.get, tag)
        }
    }
}
