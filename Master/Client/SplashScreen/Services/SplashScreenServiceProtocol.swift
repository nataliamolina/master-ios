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
    
    func checkServerStatus(onComplete: @escaping (_ result: ServerStatus?, _ error: CMError?) -> Void)
    func checkSessionToken(onComplete: @escaping (_ result: Bool, _ error: CMError?) -> Void)
}
