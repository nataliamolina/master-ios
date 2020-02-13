//
//  CMError.swift
//  Master
//
//  Created by Carlos Mejía on 12/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct CMError: Error {
    let error: String
    let details: Error?
    
    var localizedDescription: String {
        return error
    }
}
