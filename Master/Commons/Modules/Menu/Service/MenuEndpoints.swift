//
//  MenuEndpoints.swift
//  Master
//
//  Created by Carlos Mejía on 9/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

private enum EndpointsKeys: String {
    case logout
}

extension Endpoint {
    static var logout: String {
        return Endpoint.url(with: EndpointsKeys.logout.rawValue)
    }
}
