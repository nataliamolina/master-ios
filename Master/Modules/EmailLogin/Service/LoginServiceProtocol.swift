//
//  EmailLoginServiceProtocol.swift
//  Master
//
//  Created by Carlos Mejía on 12/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol EmailLoginServiceProtocol {
    var connectionDependency: ConnectionManagerProtocol { get }
    
    func performLoginRequest(request: LoginRequest,
                             onComplete: @escaping (_ result: LoginResponse?, _ error: CMError?) -> Void)
    
    func fetchUserSession(onComplete: @escaping (_ result: User?, _ error: CMError?) -> Void)
    func saveAuthenticationToken(_ token: String)
}
