//
//  OrderDetailService.swift
//  Master
//
//  Created by Carlos Mejía on 1/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

class OrderDetailService: OrderDetailServiceProtocol {
    // MARK: - Properties
    let connectionDependency: ConnectionManagerProtocol
    
    // MARK: - Life Cycle
    init(connectionDependency: ConnectionManagerProtocol) {
        self.connectionDependency = connectionDependency
    }
    
    // MARK: - Public Methods
    
    func fetchOrderDetailBy(id: Int,
                            onComplete: @escaping (_ result: Order?, _ error: CMError?) -> Void) {
        
        let endpoint = Endpoint.getOrderDetailBy(id: id)
        
        connectionDependency.get(url: endpoint) { (response: Order?, error: CMError?) in
            
            onComplete(response, error)
        }
    }
    
    func fetchOrderServices(id: Int,
                            onComplete: @escaping (_ result: [OrderProviderService], _ error: CMError?) -> Void) {
        
        let endpoint = Endpoint.getOrderServicesBy(id: id)
        
        connectionDependency.get(url: endpoint) { (response: [OrderProviderService]?, error: CMError?) in
            
            onComplete(response ?? [], error)
        }
    }
    
    func validateOrderRating(id: Int,
                             onComplete: @escaping (_ result: Bool, _ error: CMError?) -> Void) {
        
        let endpoint = Endpoint.validateOrderRatingBy(id: id)
        
        connectionDependency.get(url: endpoint) { (response: Bool?, error: CMError?) in
            
            onComplete(response ?? false, error)
        }
    }
}
