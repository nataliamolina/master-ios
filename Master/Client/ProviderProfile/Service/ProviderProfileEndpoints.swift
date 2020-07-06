//
//  ProviderProfileEndpoints.swift
//  Master
//
//  Created by Carlos Mejía on 16/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

private enum EndpointsKeys: String {
    case getCommentsByProviderId
    case providerServicesByCategoryId
    case providerProfileByUserId
    case providerInfoByProviderId
}

extension Endpoint {
    static func commentsBy(providerId: String) -> String {
        return Endpoint.url(with: EndpointsKeys.getCommentsByProviderId.rawValue).replace("{providerId}", with: providerId)
    }
    
    static func providerServicesBy(providerId: String, categoryId: String) -> String {
        var endpoint = Endpoint.url(with: EndpointsKeys.providerServicesByCategoryId.rawValue)
        endpoint = endpoint.replace("{providerId}", with: providerId)
        endpoint = endpoint.replace("{categoryId}", with: categoryId)
        
        return endpoint
    }
    
    static func providerProfileBy(_ userId: String) -> String {
        return Endpoint.url(with: EndpointsKeys.providerProfileByUserId.rawValue).replace("{userId}", with: userId)
    }
    
    static func providerInfoBy(_ providerId: String) -> String {
        return Endpoint.url(with: EndpointsKeys.providerInfoByProviderId.rawValue).replace("{providerId}", with: providerId)
    }
}
