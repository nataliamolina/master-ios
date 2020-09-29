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
    static func updateOrderState() -> String {
        return Endpoint.url(with: EndpointsKeys.updateOrderState.rawValue)
    }
}
