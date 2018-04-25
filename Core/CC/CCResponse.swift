//
//  CCResponse.swift
//  CryptoTracking
//
//  Created by Giancarlo on 25.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Endpoints

extension CoinExchangeResponse: ResponseParser {
    static func parse(data: Data, encoding: String.Encoding) throws -> CoinExchangeResponse {
        
        let coinData = try JSONDecoder().decode(CoinExchangeResponse.self, from: data)
        
        return CoinExchangeResponse(data: coinData.data)
    }
}

struct CoinExchangeResponse: Codable {
    let data: ExchangeDataClass
    
    enum CodingKeys: String, CodingKey {
        case data = "Data"
    }
}

struct ExchangeDataClass: Codable {
    let coinInfo: CoinInfo
    let aggregatedData: AggregatedData
    let exchanges: [Exchange]
    
    enum CodingKeys: String, CodingKey {
        case coinInfo = "CoinInfo"
        case exchanges = "Exchanges"
        case aggregatedData = "AggregatedData"
    }
}

struct CoinInfo: Codable {
    let id, name, fullName, coinInfoInternal: String
    let imageURL, url: String?
    let algorithm, proofType: String
    let totalCoinsMined, blockNumber, netHashesPerSecond: Int
    let blockReward: Double
    let blockTime: Int
    let totalVolume24H: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case fullName = "FullName"
        case coinInfoInternal = "Internal"
        case imageURL = "ImageUrl"
        case url = "Url"
        case algorithm = "Algorithm"
        case proofType = "ProofType"
        case totalCoinsMined = "TotalCoinsMined"
        case blockNumber = "BlockNumber"
        case netHashesPerSecond = "NetHashesPerSecond"
        case blockReward = "BlockReward"
        case blockTime = "BlockTime"
        case totalVolume24H = "TotalVolume24H"
    }
}

struct Exchange: Codable {
    let type, market, fromsymbol, tosymbol: String
    let flags: String
    let price: Double
    let lastupdate: Int
    let lastvolume, lastvolumeto: Double
    let lasttradeid: String
    let volume24Hour: Double
    let volume24Hourto: Double
    let open24Hour, high24Hour, low24Hour, change24Hour: Double
    let changepct24Hour: Double
    let changeday, changepctday: Double
    let supply: Int?
    let mktcap, totalvolume24H, totalvolume24Hto: Double?
    
    enum CodingKeys: String, CodingKey {
        case type = "TYPE"
        case market = "MARKET"
        case fromsymbol = "FROMSYMBOL"
        case tosymbol = "TOSYMBOL"
        case flags = "FLAGS"
        case price = "PRICE"
        case lastupdate = "LASTUPDATE"
        case lastvolume = "LASTVOLUME"
        case lastvolumeto = "LASTVOLUMETO"
        case lasttradeid = "LASTTRADEID"
        case volume24Hour = "VOLUME24HOUR"
        case volume24Hourto = "VOLUME24HOURTO"
        case open24Hour = "OPEN24HOUR"
        case high24Hour = "HIGH24HOUR"
        case low24Hour = "LOW24HOUR"
        case change24Hour = "CHANGE24HOUR"
        case changepct24Hour = "CHANGEPCT24HOUR"
        case changeday = "CHANGEDAY"
        case changepctday = "CHANGEPCTDAY"
        case supply = "SUPPLY"
        case mktcap = "MKTCAP"
        case totalvolume24H = "TOTALVOLUME24H"
        case totalvolume24Hto = "TOTALVOLUME24HTO"
    }
}


struct AggregatedData: Codable {
    let type, market, fromsymbol, tosymbol: String
    let flags: String
    let price: Double
    let lastupdate: Int
    let lastvolume, lastvolumeto: Double
    let lasttradeid: String
    let volumeday: Double
    let volumedayto: Double
    let volume24Hour: Double
    let volume24Hourto: Double
    let openday, highday, lowday: Double
    let open24Hour, high24Hour, low24Hour: Double
    let lastmarket: String
    let change24Hour, changepct24Hour, changeday, changepctday: Double
    let supply: Int?
    let mktcap, totalvolume24H, totalvolume24Hto: Double?

    enum CodingKeys: String, CodingKey {
        case type = "TYPE"
        case market = "MARKET"
        case fromsymbol = "FROMSYMBOL"
        case tosymbol = "TOSYMBOL"
        case flags = "FLAGS"
        case price = "PRICE"
        case lastupdate = "LASTUPDATE"
        case lastvolume = "LASTVOLUME"
        case lastvolumeto = "LASTVOLUMETO"
        case lasttradeid = "LASTTRADEID"
        case volumeday = "VOLUMEDAY"
        case volumedayto = "VOLUMEDAYTO"
        case volume24Hour = "VOLUME24HOUR"
        case volume24Hourto = "VOLUME24HOURTO"
        case openday = "OPENDAY"
        case highday = "HIGHDAY"
        case lowday = "LOWDAY"
        case open24Hour = "OPEN24HOUR"
        case high24Hour = "HIGH24HOUR"
        case low24Hour = "LOW24HOUR"
        case lastmarket = "LASTMARKET"
        case change24Hour = "CHANGE24HOUR"
        case changepct24Hour = "CHANGEPCT24HOUR"
        case changeday = "CHANGEDAY"
        case changepctday = "CHANGEPCTDAY"
        case supply = "SUPPLY"
        case mktcap = "MKTCAP"
        case totalvolume24H = "TOTALVOLUME24H"
        case totalvolume24Hto = "TOTALVOLUME24HTO"
    }
}

extension CoinListResponse: ResponseParser {
    static func parse(data: Data, encoding: String.Encoding) throws -> CoinListResponse {
        let coinData = try JSONDecoder().decode(CoinListResponse.self, from: data)
        
        return CoinListResponse(data: coinData.data)
    }
}

struct CoinListResponse: Codable {
    let data: [String: CoinData]
    
    enum CodingKeys: String, CodingKey {
        case data = "Data"
    }
}

struct CoinData: Codable {
    let id, url, imageURL, name: String
    let symbol, coinName, fullName, algorithm: String
    let proofType, fullyPremined, totalCoinSupply, preMinedValue: String
    let totalCoinsFreeFloat, sortOrder: String
    let sponsored: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case url = "Url"
        case imageURL = "ImageUrl"
        case name = "Name"
        case symbol = "Symbol"
        case coinName = "CoinName"
        case fullName = "FullName"
        case algorithm = "Algorithm"
        case proofType = "ProofType"
        case fullyPremined = "FullyPremined"
        case totalCoinSupply = "TotalCoinSupply"
        case preMinedValue = "PreMinedValue"
        case totalCoinsFreeFloat = "TotalCoinsFreeFloat"
        case sortOrder = "SortOrder"
        case sponsored = "Sponsored"
    }
}

