//
//  Comment.swift
//  Master
//
//  Created by Carlos Mejía on 16/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct Comment: Codable {
    let id: Int
    let text: String
    let author: User
    let score: Double
}
