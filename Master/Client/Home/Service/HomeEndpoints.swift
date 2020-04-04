//
//  HomeEndpoints.swift
//  Master
//
//  Created by Carlos Mejía on 14/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

private enum EndpointsKeys: String {
    case services
}

extension Endpoint {
    static var services: String {
        return Endpoint.url(with: EndpointsKeys.services.rawValue)
    }
}
