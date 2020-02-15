//
//  OrdersService.swift
//  Master
//
//  Created by Carlos Mejía on 14/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

class OrdersService: OrdersServiceProtocol {
    // MARK: - Properties
    let connectionDependency: ConnectionManagerProtocol
    
    // MARK: - Life Cycle
    init(connectionDependency: ConnectionManagerProtocol) {
        self.connectionDependency = connectionDependency
    }
    
    // MARK: - Public Methods
    
    func fetchOrders(onComplete: @escaping (_ result: [Order]?, _ error: CMError?) -> Void) {
        connectionDependency.get(url: Endpoint.orders) { (response: [Order]?, error: CMError?) in
            onComplete(response, error)
        }
    }
}
