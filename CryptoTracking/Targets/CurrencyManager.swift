//
//  CurrencyManager.swift
//  CryptoTracking
//
//  Created by Giancarlo on 27.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Foundation

public typealias CurrencyResponseList = [String: CurrencyResponse]

public struct CurrencyResponse: Decodable {
    let symbol, name, symbolNative: String
    let decimalDigits: Int
    let rounding: Double
    let code, namePlural: String
}

class CurrencyManager {
    
    func currencyList(completion: (CurrencyResponseList) -> Void) {
        if let path = Bundle.main.path(forResource: "CommonCurrency", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let currencies = try jsonDecoder.decode(CurrencyResponseList.self, from: data)
                completion(currencies)
            } catch let err{
                print(err)
            }
        }
    }

    
    /// Converts one currency to another. Amount from the converted currency is always one
    func convertCurrency(from: String, to: String, completion: @escaping (Results) -> Void) {
        SessionManager.fixerShared.start(call: FixerClient.ConvertCurrency(tag: "convert", query: ["q": "\(from)_\(to)"])) { (result) in
            result.onSuccess { value in
                guard let results = value.results["\(from)_\(to)"] else { return }
                completion(results)
                }.onError { error in
                    print(error)
            }
        }
    }
}

extension CurrencyManager {
    static let shared = CurrencyManager()
}

