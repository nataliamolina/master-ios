//
//  MenuTitle.swift
//  Master
//
//  Created by Carlos Mejía on 25/04/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

enum MenuTitle {
    case services
    case account
    case city
    
    var localized: String {
        switch self {
        case .services:
            return "menu.services".localized
            
        case .account:
            return "menu.account".localized
            
        case .city:
            return "menu.location".localized
        }
    }
}
