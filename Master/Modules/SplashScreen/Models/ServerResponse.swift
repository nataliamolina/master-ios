//
//  ServerResponse.swift
//  Master
//
//  Created by Carlos Mejía on 12/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct ServerResponse<T: Codable>: Codable {
    let isError: Bool
    let userErrorMessage: String?
    let technicalErrorMessage: String?
    let data: T
}
