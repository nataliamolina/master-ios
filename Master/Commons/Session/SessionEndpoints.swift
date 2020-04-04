//
//  SessionEndpoints.swift
//  Master
//
//  Created by Carlos Mejía on 4/04/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

private enum EndpointsKeys: String {
    case logout
    case updatePushToken
}

extension Endpoint {
    static var logout: String {
        return Endpoint.url(with: EndpointsKeys.logout.rawValue)
    }
    
    static func updateToken(with token: String) -> String {
        return Endpoint.url(with: EndpointsKeys.updatePushToken.rawValue).replace("{token}", with: token)
    }
}
