//
//  CMCResponse.swift
//  CryptoTracking
//
//  Created by Giancarlo on 24.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Endpoints
import Unbox

protocol UnboxableParser: Unboxable, ResponseParser {}

extension UnboxableParser {
    static func parse(data: Data, encoding: String.Encoding) throws -> Self {
        return try unbox(data: data)
    }
}

//struct SpecCurrencyTickerResponse: DecodableParser, Codable {
//    var id: String
//    var name: String
//    var symbol: String
//    var rank: Int
//    var priceUsd: Double
//    var priceBtc: Double
//    var marketCapUsd: Double
//    var availableSupply: Double
//    var totalSupply: Double
//    var maxSupply: Double
//    var percentChange1h: Double
//    var percentChange24h: Double
//    var percentChange7d : Double
//    var lastUpdated: Int
//}

struct SpecCurrencyTickerResponse {
    var id: String
    var name: String
    var symbol: String
    var rank: Int
    var priceUsd: Double
    var priceBtc: Double
    var marketCapUsd: Double
    var twentyFourHoursVolumeUsd: Double
    var availableSupply: Double
    var totalSupply: Double
    var maxSupply: Double
    var percentChange1h: Double
    var percentChange24h: Double
    var percentChange7d : Double
    var lastUpdated: Int
}

//struct SpecCurrencyTickerResponse: UnboxableParser {
//    var id: String
//    var name: String
//    var symbol: String
//    var rank: Int
//    var priceUsd: Double
//    var priceBtc: Double
//    var marketCapUsd: Double
//    var twentyFourHoursVolumeUsd: Double
//    var availableSupply: Double
//    var totalSupply: Double
//    var maxSupply: Double
//    var percentChange1h: Double
//    var percentChange24h: Double
//    var percentChange7d : Double
//    var lastUpdated: Int
//
//    init(unboxer: Unboxer) throws {
//        id = try unboxer.unbox(key: "id")
//        name = try unboxer.unbox(key: "name")
//        symbol = try unboxer.unbox(key: "symbol")
//        rank = try unboxer.unbox(key: "rank")
//        priceUsd = try unboxer.unbox(key: "price_usd")
//        priceBtc = try unboxer.unbox(key: "price_btc")
//        marketCapUsd = try unboxer.unbox(key: "market_cap_usd")
//        twentyFourHoursVolumeUsd = try unboxer.unbox(key: "24h_volume_usd")
//        availableSupply = try unboxer.unbox(key: "available_supply")
//        totalSupply = try unboxer.unbox(key: "total_supply")
//        maxSupply = try unboxer.unbox(key: "max_supply")
//        percentChange1h = try unboxer.unbox(key: "percent_change_1h")
//        percentChange24h = try unboxer.unbox(key: "percent_change_24h")
//        percentChange7d = try unboxer.unbox(key: "percent_change_7d")
//        lastUpdated = try unboxer.unbox(key: "last_updated")
//    }
//}

//extension SpecCurrencyTickerResponse: DecodableParser {
//    
//}

//extension SpecCurrencyTickerResponse: ResponseParser {
//    static func parse(data: Data, encoding: String.Encoding) throws -> SpecCurrencyTickerResponse {
//        let dict = try [String: Any].parse(data: data, encoding: encoding)
//
//        guard
//        let data = dict["data"] as? [String : Any],
//        let id = data["id"] as? String,
//        let name = data["name"] as? String,
//        let symbol = data["symbol"] as? String,
//        let rank = data["rank"] as? Int,
//        let priceUsd = data["price_usd"] as? Double,
//        let priceBtc = data["price_btc"] as? Double,
//        let marketCapUsd = data["market_cap_usd"] as? Double,
//        let twentyFourHoursVolumeUsd = data["24h_volume_usd"] as? Double,
//        let availableSupply = data["available_supply"] as? Double,
//        let totalSupply = data["total_supply"] as? Double,
//        let maxSupply = data["max_supply"] as? Double,
//        let percentChange1h = data["percent_change_1h"] as? Double,
//        let percentChange24h = data["percent_change_24h"] as? Double,
//        let percentChange7d = data["percent_change_7d"] as? Double,
//        let lastUpdated = data["last_updated"] as? Int
//        else {
//            throw ParsingError.invalidData(description: "invalid response. url not found")
//        }
//
//        return SpecCurrencyTickerResponse(id: id, name: name, symbol: symbol, rank: rank, priceUsd: priceUsd, priceBtc: priceBtc, marketCapUsd: marketCapUsd, twentyFourHoursVolumeUsd: twentyFourHoursVolumeUsd, availableSupply: availableSupply, totalSupply: totalSupply, maxSupply: maxSupply, percentChange1h: percentChange1h, percentChange24h: percentChange24h, percentChange7d: percentChange7d, lastUpdated: lastUpdated)
//    }
//}
