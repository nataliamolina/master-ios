//
//  Endpoint.swift
//  Master
//
//  Created by Carlos Mejía on 11/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct Endpoint {
    static var base: String {
        let endpoint = Utils.plist?.value(forKey: "ApiEndpoint") as? String
        
        return endpoint ?? ""
    }
    
    static func url(with key: String) -> String {
        return base + ((Utils.endpoints?.value(forKey: key) as? String) ?? "")
    }
}
