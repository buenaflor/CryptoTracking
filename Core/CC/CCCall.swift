//
//  CCCall.swift
//  CryptoTracking
//
//  Created by Giancarlo on 25.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Endpoints

extension CCClient {
    
    struct GetCoinData: Call {
        typealias ResponseType = CoinExchangeResponse
        
        var tag: String
        
        var query: Parameters
        
        var request: URLRequestEncodable {
            return Request(.get, tag, query: query)
        }
    }
    
    struct GetCoinList: Call {
        typealias ResponseType = CoinListResponse
        
        var tag: String
        
        var request: URLRequestEncodable {
            return Request(.get, tag)
        }
    }
    
}
