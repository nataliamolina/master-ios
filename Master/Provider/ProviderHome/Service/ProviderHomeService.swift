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
    
    func fetchProviderServices(onComplete: @escaping (_ result: [ProviderService], _ error: CMError?) -> Void) {
        connectionDependency.get(url: Endpoint.getProviderServices) { (response: [ProviderService]?, error: CMError?) in
            onComplete(response ?? [], error)
        }
    }
    
    func fetchProviderOrders(onComplete: @escaping (_ result: [Order], _ error: CMError?) -> Void) {
        connectionDependency.get(url: Endpoint.getProviderOrders) { (response: [Order]?, error: CMError?) in
            onComplete(response ?? [], error)
        }
    }
    
    func fetchProviderInfo(onComplete: @escaping ([ProviderInfoServiceModel], CMError?) -> Void) {
        connectionDependency.get(url: Endpoint.getProviderInfo) { (response: [ProviderInfoServiceModel]?, error: CMError?) in
            onComplete(response ?? [], error)
        }
    }
}
