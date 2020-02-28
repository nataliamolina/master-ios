//
//  CheckoutService.swift
//  Master
//
//  Created by Carlos Mejía on 28/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

/*

protocol CheckoutServiceProtocol {
    var connectionDependency: ConnectionManagerProtocol { get }
    
    func performCheckout(request: CheckoutRequest,
                         onComplete: @escaping (_ result: LoginResponse?, _ error: CMError?) -> Void)
}

class CheckoutService: CheckoutServiceProtocol {
    // MARK: - Properties
    let connectionDependency: ConnectionManagerProtocol
    
    // MARK: - Life Cycle
    init(connectionDependency: ConnectionManagerProtocol) {
        self.connectionDependency = connectionDependency
    }
    
    // MARK: - Public Methods
    
    func performCheckout(request: CheckoutRequest,
                         onComplete: @escaping (_ result: LoginResponse?, _ error: CMError?) -> Void) {
        
        connectionDependency
            .post(url: Endpoint.Checkout, request: request) { (response: LoginResponse?, error: CMError?) in
                
                onComplete(response, error)
        }
    }
}
*/
