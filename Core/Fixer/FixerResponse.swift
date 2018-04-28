//
//  FixerResponse.swift
//  CryptoTracking
//
//  Created by Giancarlo on 27.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Endpoints

struct ConvertCurrencyResponse: Codable {
    let results: [String: Results]
}

struct Results: Codable {
    let fr, to: String
    let val: Double
}

struct ConvertedInfo: Codable {
    let id, fr, to: String
    let val: Double
}

extension ConvertCurrencyResponse: ResponseParser {
    static func parse(data: Data, encoding: String.Encoding) throws -> ConvertCurrencyResponse {
        
        let convertedCurrency = try JSONDecoder().decode(ConvertCurrencyResponse.self, from: data)
        
        return ConvertCurrencyResponse(results: convertedCurrency.results)
    }
}
