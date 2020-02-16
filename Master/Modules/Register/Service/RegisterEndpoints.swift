//
//  RegisterEndpoints.swift
//  Master
//
//  Created by Carlos Mejía on 13/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

private enum EndpointsKeys: String {
    case register
}

extension Endpoint {
    static var register: String {
        return Endpoint.url(with: EndpointsKeys.register.rawValue)
    }
}
