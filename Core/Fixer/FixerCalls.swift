//
//  FixerCalls.swift
//  CryptoTracking
//
//  Created by Giancarlo on 27.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Endpoints

extension FixerClient {
    struct ConvertCurrency: Call {
        typealias ResponseType = ConvertCurrencyResponse
        
        var tag: String
        var query: Parameters
        
        var request: URLRequestEncodable {
            return Request(.get, tag, query: query)
        }
    }
}
