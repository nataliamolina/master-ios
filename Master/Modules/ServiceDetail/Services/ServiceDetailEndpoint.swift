//
//  ServiceDetailEndpoint.swift
//  Master
//
//  Created by Carlos Mejía on 15/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

extension Endpoint {
    static func serviceDetailById(_ id: Int) -> String {
        return base + "provider/service/category/\(id)"
    }
}
