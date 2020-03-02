//
//  ServerStatus.swift
//  Master
//
//  Created by Carlos Mejía on 12/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct ServerStatus: Codable {
    let isOnline: Bool
    let offlineMessage: String?
    let helpUrl: String?
}
