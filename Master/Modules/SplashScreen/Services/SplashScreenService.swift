//
//  SplashScreenService.swift
//  Master
//
//  Created by Carlos Mejía on 12/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

class SplashScreenService: SplashScreenServiceProtocol {
    // MARK: - Properties
    let connectionDependency: ConnectionManagerProtocol
    
    // MARK: - Life Cycle
    init(connectionDependency: ConnectionManagerProtocol) {
        self.connectionDependency = connectionDependency
        
        setupHeaders()
    }
    
    // MARK: - Public Methods
    func checkServerStatus(onComplete: @escaping (ServerStatus?, CMError?) -> Void) {
        connectionDependency
            .get(url: Endpoint.serverStatus) {
                (response: ServerStatus?, error: CMError?) in
                
                onComplete(response, error)
        }
    }
    
    func checkSessionToken(onComplete: @escaping (Bool, CMError?) -> Void) {
        connectionDependency
            .get(url: Endpoint.validateSessionToken) {
                (response: EmptyCodable?, error: CMError?) in
                
                onComplete(response != nil, error)
        }
    }
    
    // MARK: - Private Methods
    
    private func setupHeaders() {
        connectionDependency.setCustomHeaders([
            "58ecda0e640": "a9a1384d84d95902e718859d56261c1a"
        ])
    }
}
