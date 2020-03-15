//
//  ProviderHomeService.swift
//  Master
//
//  Created by Carlos Mejía on 14/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

class ProviderHomeService: ProviderHomeServiceProtocol {
    // MARK: - Properties
    let connectionDependency: ConnectionManagerProtocol
    
    // MARK: - Life Cycle
    init(connectionDependency: ConnectionManagerProtocol) {
        self.connectionDependency = connectionDependency
    }
    
    // MARK: - Public Methods
    
    func fetchProfile(userId: Int, onComplete: @escaping (_ result: Provider?, _ error: CMError?) -> Void) {
        let endpoint = Endpoint.providerProfileBy("\(userId)")
        
        connectionDependency.get(url: endpoint) { (response: Provider?, error: CMError?) in
            onComplete(response, error)
        }
    }
}
