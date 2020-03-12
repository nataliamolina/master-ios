//
//  RegisterService.swift
//  Master
//
//  Created by Carlos Mejía on 13/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

class RegisterService: RegisterServiceProtocol {
    // MARK: - Properties
    let connectionDependency: ConnectionManagerProtocol
    
    // MARK: - Life Cycle
    init(connectionDependency: ConnectionManagerProtocol) {
        self.connectionDependency = connectionDependency
    }
    
    // MARK: - Public Methods
    
    func performRegister(request: RegisterRequest,
                         onComplete: @escaping (_ result: LoginResponse?, _ error: CMError?) -> Void) {
        
        connectionDependency
            .post(url: Endpoint.register, request: request) { (response: LoginResponse?, error: CMError?) in
                
                onComplete(response, error)
        }
    }
}
