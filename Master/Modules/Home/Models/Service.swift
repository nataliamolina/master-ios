//
//  Service.swift
//  Master
//
//  Created by Carlos Mejía on 14/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct Service: Codable {
    let name: String
    let serviceCategories: [ServiceCategory]
}
