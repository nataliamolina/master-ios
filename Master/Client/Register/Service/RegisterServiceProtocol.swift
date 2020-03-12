//
//  RegisterServiceProtocol.swift
//  Master
//
//  Created by Carlos Mejía on 13/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol RegisterServiceProtocol {
    var connectionDependency: ConnectionManagerProtocol { get }
    
    func performRegister(request: RegisterRequest,
                         onComplete: @escaping (_ result: LoginResponse?, _ error: CMError?) -> Void)
}
