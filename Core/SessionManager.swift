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
    case fixerClient
    case cwClient
    
    var client: Client {
        switch self {
        case .cmcClient:
            return CMCClient()
        case .ccClient:
            return CCClient()
        case .fixerClient:
            return FixerClient()
        case .cwClient:
            return CWClient()
        }
    }

    
}

class SessionManager {
    let cmcSession: Session<CMCClient>
    let ccSession: Session<CCClient>
    let fixerSession: Session<FixerClient>
    let cwSession: Session<CWClient>

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
        
        fixerSession = {
            let client = FixerClient()
            let session = Session(with: client)
            #if DEBUG
            session.debug = true
            #endif
            
            return session
        }()
        
        cwSession = {
            let client = CWClient()
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
        case .fixerClient:
            let task = fixerSession.start(call: call, completion: completion)
            return task
        case .cwClient:
            let task = cwSession.start(call: call, completion: completion)
            return task
        }
    }
}
