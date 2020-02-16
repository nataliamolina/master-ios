//
//  HomeService.swift
//  Master
//
//  Created by Carlos Mejía on 14/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

class HomeService: HomeServiceProtocol {
    // MARK: - Properties
    let connectionDependency: ConnectionManagerProtocol
    
    // MARK: - Life Cycle
    init(connectionDependency: ConnectionManagerProtocol) {
        self.connectionDependency = connectionDependency
    }
    
    // MARK: - Public Methods
    
    func fetchServices(onComplete: @escaping (_ result: [Service]?, _ error: CMError?) -> Void) {
        connectionDependency.get(url: Endpoint.services) { (response: [Service]?, error: CMError?) in
            onComplete(response, error)
        }
    }
    
    func updatePushToken(_ token: String, onComplete: @escaping (_ result: String?, _ error: CMError?) -> Void) {
        connectionDependency.put(url: Endpoint.services) { (response: String?, error: CMError?) in
            onComplete(response, error)
        }
    }
}
