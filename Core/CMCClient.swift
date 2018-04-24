//
//  CMCClient.swift
//  CryptoTracking
//
//  Created by Giancarlo on 24.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Endpoints

class CMCClient: Client {
    
    let client: AnyClient = {
        return AnyClient(baseURL: URL(string: "https://api.coinmarketcap.com/v1/")!)
    }()
    
    func encode<C>(call: C) -> URLRequest where C : Call {
        var request = client.encode(call: call)
        
        request.apply(header: nil)
        
        return request
    }
    
    func parse<C>(sessionTaskResult result: URLSessionTaskResult, for call: C) throws -> C.ResponseType.OutputType where C : Call {
        return try client.parse(sessionTaskResult: result, for: call)
    }
}
