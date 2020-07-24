//
//  AddProviderServiceService.swift
//  Master
//
//  Created by Carlos Mejía on 2/04/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

class AddProviderServiceService: AddProviderServiceServiceProtocol {
    // MARK: - Properties
    let connectionDependency: ConnectionManagerProtocol
    
    // MARK: - Life Cycle
    init(connectionDependency: ConnectionManagerProtocol) {
        self.connectionDependency = connectionDependency
    }
    
    // MARK: - Public Methods
    
    func getServiceCategories(onComplete: @escaping (_ result: [ServiceCategory], _ error: CMError?) -> Void) {
        connectionDependency
            .get(url: Endpoint.getServiceCategories) { (response: [ServiceCategory]?, error: CMError?) in
                onComplete(response ?? [], error)
        }
    }
    
    func postProviderService(request: ProviderServiceRequest,
                             onComplete: @escaping (_ result: ProviderService?, _ error: CMError?) -> Void) {
        
        connectionDependency
            .post(url: Endpoint.postProviderService, request: request) { (response: ProviderService?, error: CMError?) in
                onComplete(response, error)
        }
    }
    
    func putProviderService(serviceId: Int, request: ProviderServiceRequest, onComplete: @escaping (ProviderService?, CMError?) -> Void) {
        connectionDependency
            .put(url: Endpoint.putServiceCategories(serviceId: serviceId), request: request) { (response: ProviderService?, error: CMError?) in
                onComplete(response, error)
        }
    }
}
