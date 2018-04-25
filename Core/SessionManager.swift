//
//  SessionManager.swift
//  CryptoTracking
//
//  Created by Giancarlo on 24.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Endpoints

class SessionManager {
    let session: Session<CMCClient>
    
    private var client: CMCClient {
        return session.client
    }
    
    init() {
        session = {
            let client = CMCClient()
            let session = Session(with: client)
            #if DEBUG
            session.debug = true
            #endif
            
            return session
        }()
    }
    
    @discardableResult
    public func start<C: Call>(call: C, completion: @escaping (Result<C.ResponseType.OutputType>) -> Void) -> URLSessionTask {
        let task = session.start(call: call, completion: completion)
        return task
    }
}
