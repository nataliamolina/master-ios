//
//  EmailLoginEndpoints.swift
//  Master
//
//  Created by Carlos Mejía on 12/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

private enum EndpointsKeys: String {
    case emailLogin
    case getUserSession
    case gmailLogin
    case appleLogin
}

extension Endpoint {
    static var emailLogin: String {
        return Endpoint.url(with: EndpointsKeys.emailLogin.rawValue)
    }
    
    static var userSession: String {
        return Endpoint.url(with: EndpointsKeys.getUserSession.rawValue)
    }
    
    static var gmailLogin: String {
        return Endpoint.url(with: EndpointsKeys.gmailLogin.rawValue)
    }
    
    static var appleLogin: String {
        return Endpoint.url(with: EndpointsKeys.appleLogin.rawValue)
    }
}
