//
//  SplashScreenEndpoints.swift
//  Master
//
//  Created by Carlos Mejía on 12/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

private enum EndpointsKeys: String {
    case serverStatus
    case validateSession
}

extension Endpoint {
    static var serverStatus: String {
        return Endpoint.url(with: EndpointsKeys.serverStatus.rawValue)
    }
    
    static var validateSessionToken: String {
        return Endpoint.url(with: EndpointsKeys.validateSession.rawValue)
    }
}
