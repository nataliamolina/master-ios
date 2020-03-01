//
//  OrderDetailEndpoints.swift
//  Master
//
//  Created by Carlos Mejía on 1/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

private enum EndpointsKeys: String {
    case getOrderById
    case getOrderServicesById
    case validateOrderRatingById
}

extension Endpoint {
    static func getOrderDetailBy(id: Int) -> String {
        var endpoint = Endpoint.url(with: EndpointsKeys.getOrderById.rawValue)
        endpoint = endpoint.replace("{orderId}", with: id.asString)
        
        return endpoint
    }
    
    static func getOrderServicesBy(id: Int) -> String {
        var endpoint = Endpoint.url(with: EndpointsKeys.getOrderServicesById.rawValue)
        endpoint = endpoint.replace("{orderId}", with: id.asString)
        
        return endpoint
    }
    
    static func validateOrderRatingBy(id: Int) -> String {
        var endpoint = Endpoint.url(with: EndpointsKeys.validateOrderRatingById.rawValue)
        endpoint = endpoint.replace("{orderId}", with: id.asString)
        
        return endpoint
    }
}
