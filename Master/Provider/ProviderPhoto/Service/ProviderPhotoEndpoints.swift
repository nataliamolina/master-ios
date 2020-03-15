//
//  ProviderPhotoEndpoints.swift
//  Master
//
//  Created by Carlos Mejía on 14/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

private enum EndpointsKeys: String {
    case updateProviderPhoto
}

extension Endpoint {
    static var updateProviderPhoto: String {
        return Endpoint.url(with: EndpointsKeys.updateProviderPhoto.rawValue)
    }
}
