//
//  SessionManager.swift
//  CryptoTracking
//
//  Created by Giancarlo on 24.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Endpoints

enum ClientType {
    case cmcClient
    case ccClient
    
    var client: Client {
        switch self {
        case .cmcClient:
            return CMCClient()
        case .ccClient:
            return CCClient()
        }
    }

    
}

class SessionManager {
    let cmcSession: Session<CMCClient>
    let ccSession: Session<CCClient>
    
    private var cmcClient: CMCClient {
        return cmcSession.client
    }
    
    var clientType: ClientType?
    
    init(clientType: ClientType) {
        self.clientType = clientType
        ccSession = {
            let client = CCClient()
            let session = Session(with: client)
            #if DEBUG
            session.debug = true
            #endif
            
            return session
        }()
        
        cmcSession = {
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
        guard let clientType = clientType else { fatalError("ClientType not defined") }
        
        switch clientType {
        case .ccClient:
            let task = ccSession.start(call: call, completion: completion)
            return task
        case .cmcClient:
            let task = cmcSession.start(call: call, completion: completion)
            return task
        }
    }
}
