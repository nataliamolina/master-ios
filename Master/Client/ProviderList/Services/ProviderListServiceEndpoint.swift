//
//  ServiceDetailEndpoint.swift
//  Master
//
//  Created by Carlos Mejía on 15/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

private enum EndpointsKeys: String {
    case serviceDetail
}

extension Endpoint {
    static func serviceDetailById(_ id: Int) -> String {
        return Endpoint.url(with: EndpointsKeys.serviceDetail.rawValue).replace("{id}", with: "\(id)")
    }
}
