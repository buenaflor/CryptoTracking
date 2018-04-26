//
//  CMCResponse.swift
//  CryptoTracking
//
//  Created by Giancarlo on 24.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Endpoints

struct CoinTickerResponse {
    var items: [CoinTicker]
}

struct CoinTicker: Codable {
    let id, name, symbol: String
    let rank: String
    let priceUsd, priceBtc, the24HVolumeUsd, marketCapUsd: String
    let availableSupply, totalSupply: String
    let maxSupply: String?
    let percentChange1H, percentChange24H, percentChange7D: String
    let lastUpdated: String

    enum CodingKeys: String, CodingKey {
        case id, name, symbol, rank
        case priceUsd = "price_usd"
        case priceBtc = "price_btc"
        case the24HVolumeUsd = "24h_volume_usd"
        case marketCapUsd = "market_cap_usd"
        case availableSupply = "available_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case percentChange1H = "percent_change_1h"
        case percentChange24H = "percent_change_24h"
        case percentChange7D = "percent_change_7d"
        case lastUpdated = "last_updated"
    }
}

extension CoinTickerResponse: ResponseParser {
    static func parse(data: Data, encoding: String.Encoding) throws -> CoinTickerResponse {

        let coinTickers = try JSONDecoder().decode([CoinTicker].self, from: data)

        return CoinTickerResponse(items: coinTickers)
    }
}

