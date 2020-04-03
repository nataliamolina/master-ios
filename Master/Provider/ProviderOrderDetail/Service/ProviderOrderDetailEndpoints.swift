//
//  ProviderOrderDetailEndpoints.swift
//  Master
//
//  Created by Carlos Mejía on 2/04/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

private enum EndpointsKeys: String {
    case updateOrderState
}

extension Endpoint {
    static func updateOrderState(orderId: Int, stateId: Int) -> String {
        var endpoint = Endpoint.url(with: EndpointsKeys.updateOrderState.rawValue)
        endpoint = endpoint.replacingOccurrences(of: "{orderId}", with: orderId.asString)
        endpoint = endpoint.replacingOccurrences(of: "{stateId}", with: stateId.asString)

        return endpoint
    }
}
