//
//  ProviderRegisterService.swift
//  Master
//
//  Created by Carlos Mejía on 14/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

class ProviderRegisterService: ProviderRegisterServiceProtocol {
    // MARK: - Properties
    let connectionDependency: ConnectionManagerProtocol
    
    // MARK: - Life Cycle
    init(connectionDependency: ConnectionManagerProtocol) {
        self.connectionDependency = connectionDependency
    }
    
    // MARK: - Public Methods
    
    func createProvider(request: ProviderRequest, onComplete: @escaping (_ result: Provider?, _ error: CMError?) -> Void) {
        connectionDependency.post(url: Endpoint.registerProvider, request: request) { (response: Provider?, error: CMError?) in
            onComplete(response, error)
        }
    }
}
