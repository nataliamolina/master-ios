//
//  ProviderRegisterEndpoints.swift
//  Master
//
//  Created by Carlos Mejía on 14/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

private enum EndpointsKeys: String {
    case registerProvider
}

extension Endpoint {
    static var registerProvider: String {
        return Endpoint.url(with: EndpointsKeys.registerProvider.rawValue)
    }
}
