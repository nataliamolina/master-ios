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
    
    func fetchProviderInfo(id: Int, onComplete: @escaping ([ProviderInfoServiceModel], CMError?) -> Void) {
        connectionDependency.get(url: Endpoint.getProviderInfo(providerId: id)) { (response: [ProviderInfoServiceModel]?, error: CMError?) in
            onComplete(response ?? [], error)
        }
    }
    
    func deleteProviderService(serviceId: Int, onComplete: @escaping (Bool?, CMError?) -> Void) {
        connectionDependency
            .delete(url: Endpoint.deleteProviderService(serviceId: serviceId)) { (response: Bool?, error: CMError?) in
                onComplete(response, error)
        }
    }
    
    func deleteProviderInfo(providerId: Int, onComplete: @escaping (_ result: [ProviderInfoServiceModel]?, _ error: CMError?) -> Void) {
           connectionDependency.delete(url: Endpoint.deleteProviderInfo(providerId: providerId)) { (response: [ProviderInfoServiceModel]?, error: CMError?) in
               onComplete(response, error)
           }
       }
}
