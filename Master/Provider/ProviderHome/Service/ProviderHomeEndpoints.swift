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
    case getProviderInfoByProviderId
    case deleteProviderService
    case deleteProviderInfo
}

extension Endpoint {
    static var getProviderOrders: String {
        return Endpoint.url(with: EndpointsKeys.getProviderOrders.rawValue)
    }
    
    static var getProviderServices: String {
        return Endpoint.url(with: EndpointsKeys.getProviderServices.rawValue)
    }
    
    static func getProviderInfo(providerId: Int) -> String {
        var endpoint = Endpoint.url(with: EndpointsKeys.getProviderInfoByProviderId.rawValue)
        endpoint = endpoint.replace("{providerId}", with: providerId.asString)
        
        return endpoint
    }
    
    static func deleteProviderService(serviceId: Int) -> String {
        var endpoint = Endpoint.url(with: EndpointsKeys.deleteProviderService.rawValue)
        endpoint = endpoint.replace("{serviceId}", with: serviceId.asString)
        
        return endpoint
    }
    
    static func deleteProviderInfo(providerId: Int) -> String {
        var endpoint = Endpoint.url(with: EndpointsKeys.deleteProviderInfo.rawValue)
        endpoint = endpoint.replace("{providerId}", with: providerId.asString)
        
        return endpoint
    }
}
