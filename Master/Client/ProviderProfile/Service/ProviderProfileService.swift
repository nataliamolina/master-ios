//
//  ProviderProfileService.swift
//  Master
//
//  Created by Carlos Mejía on 16/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

class ProviderProfileService: ProviderProfileServiceProtocol {
        
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
    
    func fetchProviderServices(providerId: Int,
                               categoryId: Int,
                               onComplete: @escaping (_ result: [ProviderService]?, _ error: CMError?) -> Void) {
        
        let endpoint = Endpoint.providerServicesBy(providerId: "\(providerId)", categoryId: "\(categoryId)")

        connectionDependency.get(url: endpoint) { (response: [ProviderService]?, error: CMError?) in
            onComplete(response, error)
        }
    }
    
    func fetchComments(providerId: Int, onComplete: @escaping (_ result: CommentsResponse?, _ error: CMError?) -> Void) {
        let endpoint = Endpoint.commentsBy(providerId: "\(providerId)")

        connectionDependency.get(url: endpoint) { (response: CommentsResponse?, error: CMError?) in
            onComplete(response, error)
        }
    }
    
    func fetchProviderInfo(providerId: Int, onComplete: @escaping ([ProviderInfoServiceModel]?, CMError?) -> Void) {
        let endpoint = Endpoint.providerInfoBy("\(providerId)")

        connectionDependency.get(url: endpoint) { (response: [ProviderInfoServiceModel]?, error: CMError?) in
            onComplete(response, error)
        }
    }
}
