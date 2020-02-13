//
//  SplashScreenEndpoints.swift
//  Master
//
//  Created by Carlos Mejía on 12/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

extension Endpoint {
    static var serverStatus: String {
        return base + "server/ios"
    }
    
    static var validateSessionToken: String {
        return base + "login/validate"
    }
    
    static var userSession: String {
        return base + "user"
    }
}
