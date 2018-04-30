//
//  CWCalls.swift
//  CryptoTracking
//
//  Created by Giancarlo on 30.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Endpoints

extension CWClient {
    struct GetMarkets: Call {
        typealias ResponseType = MarketsResponse
        
        var tag: String

        var request: URLRequestEncodable {
            return Request(.get, tag)
        }
    }
}
