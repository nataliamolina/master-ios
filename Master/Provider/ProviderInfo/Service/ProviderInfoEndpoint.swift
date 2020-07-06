//
//  ProviderInfoEndpoint.swift
//  Master
//
//  Created by Maria Paula Gomez Prieto on 7/5/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

private enum EndpointsKeys: String {
    case editProviderInfo
    case addProviderInfo
}
extension Endpoint {
    
    static var addProviderInfo: String {
        return Endpoint.url(with: EndpointsKeys.addProviderInfo.rawValue)
    }
    
    static func editProviderInfo(providerId: Int) -> String {
        var endpoint = Endpoint.url(with: EndpointsKeys.editProviderInfo.rawValue)
        endpoint = endpoint.replace("{providerId}", with: providerId.asString)
        
        return endpoint
    }
}
