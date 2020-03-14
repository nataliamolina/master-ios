//
//  ProviderMainService.swift
//  Master
//
//  Created by Carlos Mejía on 14/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

class ProviderMainService: ProviderMainServiceProtocol {
    // MARK: - Properties
    let connectionDependency: ConnectionManagerProtocol
    
    // MARK: - Life Cycle
    init(connectionDependency: ConnectionManagerProtocol) {
        self.connectionDependency = connectionDependency
    }
    
    // MARK: - Public Methods
    
    func getProviderProfile(onComplete: @escaping (_ result: Provider?, _ error: CMError?) -> Void) {
        connectionDependency.get(url: Endpoint.getProviderProfile) { (response: Provider?, error: CMError?) in
            onComplete(response, error)
        }
    }
    
    func getProviderPhoto(onComplete: @escaping (_ result: String?, _ error: CMError?) -> Void) {
        connectionDependency.get(url: Endpoint.getProviderPhoto) { (response: String?, error: CMError?) in
            onComplete(response, error)
        }
    }
}
