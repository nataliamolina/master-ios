//
//  ProviderListService.swift
//  Master
//
//  Created by Carlos Mejía on 15/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

class ProviderListService: ProviderListServiceProtocol {
    // MARK: - Properties
    let connectionDependency: ConnectionManagerProtocol
    
    // MARK: - Life Cycle
    init(connectionDependency: ConnectionManagerProtocol) {
        self.connectionDependency = connectionDependency
    }
    
    // MARK: - Public Methods
    
    func fetchServiceDetailById(_ id: Int,
                                onComplete: @escaping (_ result: [ProviderWithScore]?, _ error: CMError?) -> Void) {
        
        let endpoint = Endpoint.serviceDetailById(id)
        
        connectionDependency.get(url: endpoint) { (response: [ProviderWithScore]?, error: CMError?) in
            
            onComplete(response, error)
        }
    }
}
