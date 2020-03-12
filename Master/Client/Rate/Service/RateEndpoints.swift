//
//  RateEndpoints.swift
//  Master
//
//  Created by Carlos Mejía on 9/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

private enum EndpointsKeys: String {
    case addComment
}

extension Endpoint {
    static var addComment: String {
        return Endpoint.url(with: EndpointsKeys.addComment.rawValue)
    }
}
