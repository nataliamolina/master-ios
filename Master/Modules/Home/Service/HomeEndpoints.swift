//
//  HomeEndpoints.swift
//  Master
//
//  Created by Carlos Mejía on 14/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

extension Endpoint {
    static var services: String {
        return base + "services"
    }
    
    static func updateToken(with token: String) -> String {
        return base + "user/push-token/" + token
    }
}
