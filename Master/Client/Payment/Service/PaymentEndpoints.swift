//
//  PaymentEndpoints.swift
//  Master
//
//  Created by Carlos Mejía on 3/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

private enum EndpointsKeys: String {
    case deleteCards
    case payOrder
}

extension Endpoint {
    static var deleteCards: String {
        return Endpoint.url(with: EndpointsKeys.deleteCards.rawValue)
    }
    
    static var pay: String {
        return Endpoint.url(with: EndpointsKeys.payOrder.rawValue)
    }
}
