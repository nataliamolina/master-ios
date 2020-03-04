//
//  PaymentService.swift
//  Master
//
//  Created by Carlos Mejía on 3/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

class PaymentService: PaymentServiceProtocol {
    // MARK: - Properties
    let connectionDependency: ConnectionManagerProtocol
    
    // MARK: - Life Cycle
    init(connectionDependency: ConnectionManagerProtocol) {
        self.connectionDependency = connectionDependency
    }
    
    // MARK: - Public Methods
    
    func performPayment(request: PaymentRequest,
                        onComplete: @escaping (_ result: PaymentResponse?, _ error: CMError?) -> Void) {
        
        connectionDependency
            .post(url: Endpoint.pay, request: request) { (response: PaymentResponse?, error: CMError?) in
                
                onComplete(response, error)
        }
    }
    
    func deleteAllCards(onComplete: @escaping (_ result: Bool, _ error: CMError?) -> Void) {
        
        connectionDependency
            .delete(url: Endpoint.deleteCards) { (response: Bool?, error: CMError?) in
                
                onComplete(response ?? false, error)
        }
    }
}
