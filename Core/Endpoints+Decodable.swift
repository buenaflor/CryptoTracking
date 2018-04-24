//
//  Endpoints+Decodable.swift
//  CryptoTracking
//
//  Created by Giancarlo on 24.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Endpoints

// Unused

public protocol DecodableParser: Decodable, ResponseParser { }

public extension DecodableParser {
    static func parse(data: Data, encoding: String.Encoding) throws -> Self {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(self, from: data)
    }
}

public extension Encodable {
    func JSON() throws -> String {
        let data = try JSONEncoder().encode(self)
        
        guard let string = String(data: data, encoding: .utf8) else {
            let context = EncodingError.Context(codingPath: [], debugDescription: "couldn't encode object")
            throw EncodingError.invalidValue(data, context)
        }
        
        return string
    }
}
