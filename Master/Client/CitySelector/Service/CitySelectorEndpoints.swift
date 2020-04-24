//
//  CitySelectorEndpoints.swift
//  Master
//
//  Created by Carlos Mejía on 24/04/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

private enum EndpointsKeys: String {
    case cities
}

extension Endpoint {
    static var cities: String {
        return Endpoint.url(with: EndpointsKeys.cities.rawValue)
    }
}
