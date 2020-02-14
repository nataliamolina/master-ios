//
//  EmailLoginService.swift
//  Master
//
//  Created by Carlos Mejía on 11/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

class EmailLoginService: EmailLoginServiceProtocol {
    // MARK: - Properties
    let connectionDependency: ConnectionManagerProtocol
    
    // MARK: - Life Cycle
    init(connectionDependency: ConnectionManagerProtocol) {
        self.connectionDependency = connectionDependency
    }
    
    // MARK: - Public Methods
    
    func performLoginRequest(request: LoginRequest, onComplete: @escaping (LoginResponse?, CMError?) -> Void) {
        connectionDependency
            .post(url: Endpoint.emailLogin, request: request) {
                (response: LoginResponse?, error: CMError?) in
                
                onComplete(response, error)
        }
    }
    
    func fetchUserSession(onComplete: @escaping (User?, CMError?) -> Void) {
        connectionDependency
            .get(url: Endpoint.userSession) {
                (response: User?, error: CMError?) in
                
                onComplete(response, error)
        }
    }
    
    func saveAuthenticationToken(_ token: String) {
        connectionDependency.setAuthenticationToken(token)
    }
    
    func performGmailRequest(request: GmailRequest,
                             onComplete: @escaping (_ result: LoginResponse?, _ error: CMError?) -> Void) {
        
        connectionDependency
            .post(url: Endpoint.gmailLogin, request: request) {
                (response: LoginResponse?, error: CMError?) in
                
                onComplete(response, error)
        }
    }
}
