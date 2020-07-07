//
//  ProviderInfoServiceModel.swift
//  Master
//
//  Created by Maria Paula Gomez Prieto on 7/5/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

class ProviderInfoService: ProviderInfoServiceModelProtocol {
    // MARK: - Properties
    let connectionDependency: ConnectionManagerProtocol
    
    // MARK: - Life Cycle
    init(connectionDependency: ConnectionManagerProtocol) {
        self.connectionDependency = connectionDependency
    }
    
    // MARK: - Public Methods
    func postProviderInfo(request: ProviderInfoServiceModelRequest,
                          onComplete: @escaping (_ result: [ProviderInfoServiceModel]?, _ error: CMError?) -> Void) {
        connectionDependency
            .post(url: Endpoint.addProviderInfo, request: request) { (response: [ProviderInfoServiceModel]?, error: CMError?) in
                onComplete(response, error)
        }
    }
    
    func putProviderInfo(request: ProviderInfoServiceModel, onComplete: @escaping ([ProviderInfoServiceModel]?, CMError?) -> Void) {
        connectionDependency.put(url: Endpoint.editProviderInfo(providerId: request.id),
                                 request: request) { (response: [ProviderInfoServiceModel]?, error: CMError?) in
                                    onComplete(response, error)
                                    
        }
    }
    
    func deleteProviderInfo(providerId: Int, onComplete: @escaping (_ result: [ProviderInfoServiceModel]?, _ error: CMError?) -> Void) {
        connectionDependency.delete(url: Endpoint.deleteProviderInfo(providerId: providerId)) { (response: [ProviderInfoServiceModel]?, error: CMError?) in
            onComplete(response, error)
        }
    }
}
