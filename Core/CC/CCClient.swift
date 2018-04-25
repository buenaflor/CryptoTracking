//
//  CCClient.swift
//  CryptoTracking
//
//  Created by Giancarlo on 25.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Endpoints

class CCClient: Client {
    
    let client: AnyClient = {
        let baseURL = BaseConfig.shared.ccBaseURL
        return AnyClient(baseURL: baseURL)
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
