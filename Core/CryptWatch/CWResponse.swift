//
//  CWResponse.swift
//  CryptoTracking
//
//  Created by Giancarlo on 30.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Endpoints

struct MarketsResponse: Codable {
    let result: [MarketResult]
}

struct MarketResult: Codable {
    let id: Int
    let exchange, pair: String
    let active: Bool
    let route: String
}

extension MarketsResponse: ResponseParser {
    static func parse(data: Data, encoding: String.Encoding) throws -> MarketsResponse {
        
        let response = try JSONDecoder().decode(MarketsResponse.self, from: data)
        
        return MarketsResponse(result: response.result)
    }
}
