//
//  AddProviderServiceEndpoints.swift
//  Master
//
//  Created by Carlos Mejía on 30/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

private enum EndpointsKeys: String {
    case getServiceCategories
    case postProviderService
    case putProviderService
}

extension Endpoint {
    static var getServiceCategories: String {
        return Endpoint.url(with: EndpointsKeys.getServiceCategories.rawValue)
    }
    
    static var postProviderService: String {
        return Endpoint.url(with: EndpointsKeys.postProviderService.rawValue)
    }
    
    static func putServiceCategories(serviceId: Int) -> String {
        var endpoint = Endpoint.url(with: EndpointsKeys.putProviderService.rawValue)
        endpoint = endpoint.replace("{serviceId}", with: serviceId.asString)
        
        return endpoint
    }
}
