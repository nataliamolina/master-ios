//
//  ProviderMainEndpoints.swift
//  Master
//
//  Created by Carlos Mejía on 14/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

private enum EndpointsKeys: String {
    case getProviderPhoto
    case getProviderProfile
}

extension Endpoint {
    static var getProviderPhoto: String {
        return Endpoint.url(with: EndpointsKeys.getProviderPhoto.rawValue)
    }
    
    static var getProviderProfile: String {
        return Endpoint.url(with: EndpointsKeys.getProviderProfile.rawValue)
    }
}
