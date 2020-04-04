//
//  SessionService.swift
//  Master
//
//  Created by Carlos Mejía on 4/04/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

class SessionService: SessionServiceProtocol {
    // MARK: - Properties
    let connectionDependency: ConnectionManagerProtocol
    
    // MARK: - Life Cycle
    init(connectionDependency: ConnectionManagerProtocol) {
        self.connectionDependency = connectionDependency
    }
    
    // MARK: - Public Methods
    
    func logout(onComplete: (() -> Void)?) {
        connectionDependency.putWithBoolResponse(url: Endpoint.logout) { (_, _) in
            onComplete?()
        }
    }
    
    func updatePushToken(_ token: String, onComplete: @escaping (_ result: String?, _ error: CMError?) -> Void) {
        connectionDependency.put(url: Endpoint.updateToken(with: token)) { (response: String?, error: CMError?) in
            onComplete(response, error)
        }
    }
}
