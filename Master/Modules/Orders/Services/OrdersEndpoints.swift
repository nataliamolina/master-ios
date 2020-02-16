//
//  OrdersEndpoints.swift
//  Master
//
//  Created by Carlos Mejía on 14/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

private enum EndpointsKeys: String {
    case userOrders
}

extension Endpoint {
    static var orders: String {
        return Endpoint.url(with: EndpointsKeys.userOrders.rawValue)
    }
}
