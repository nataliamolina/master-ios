//
//  CheckoutEndpoints.swift
//  Master
//
//  Created by Carlos Mejía on 29/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

private enum EndpointsKeys: String {
    case postOrder
}

extension Endpoint {
    static var postOrder: String {
        return Endpoint.url(with: EndpointsKeys.postOrder.rawValue)
    }
}
