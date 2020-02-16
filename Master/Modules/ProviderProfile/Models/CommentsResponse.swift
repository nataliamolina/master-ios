//
//  CommentsResponse.swift
//  Master
//
//  Created by Carlos Mejía on 16/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct CommentsResponse: Codable {
    let average: Double
    let comments: [Comment]
}
