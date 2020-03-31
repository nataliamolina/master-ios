//
//  ProviderHomeEndpoints.swift
//  Master
//
//  Created by Carlos Mejía on 14/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

private enum EndpointsKeys: String {
    case getProviderOrders
    case getProviderServices
}

extension Endpoint {
    static var getProviderOrders: String {
        return Endpoint.url(with: EndpointsKeys.getProviderOrders.rawValue)
    }
    
    static var getProviderServices: String {
        return Endpoint.url(with: EndpointsKeys.getProviderServices.rawValue)
    }
}
