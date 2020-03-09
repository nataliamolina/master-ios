//
//  CommentRequest.swift
//  Master
//
//  Created by Carlos Mejía on 9/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct CommentRequest: Codable {
    let text: String
    let score: Double
    let orderId: Int
}
