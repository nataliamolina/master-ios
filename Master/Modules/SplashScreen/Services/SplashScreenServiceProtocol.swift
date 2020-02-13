//
//  SplashScreenServiceProtocol.swift
//  Master
//
//  Created by Carlos Mejía on 12/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol SplashScreenServiceProtocol {
    var connectionDependency: ConnectionManagerProtocol { get }
    
    func checkServerStatus(onComplete: @escaping (_ result: ServerStatus?, _ error: Error?) -> Void)
    func checkSessionToken(onComplete: @escaping (_ result: ServerResponse<Bool>?, _ error: Error?) -> Void)
    func fetchUserSession(onComplete: @escaping (_ result: User?, _ error: Error?) -> Void)
    func saveAuthenticationToken(_ token: String)
}
