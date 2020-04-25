//
//  MenuOption.swift
//  Master
//
//  Created by Carlos Mejía on 25/04/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

enum MenuOption {
    case orders
    case legal
    case help
    case city(name: String)
    
    var localized: String {
        switch self {
        case .orders:
            return "menu.orders".localized
            
        case .help:
            return "menu.help".localized
            
        case .legal:
            return "menu.legal".localized
            
        case .city(let name):
            return name
        }
    }
    
    var icon: UIImage? {
        var iconName: String
        
        switch self {
        case .orders:
            iconName = "clock_icon"
            
        case .help:
            iconName = "question_icon_template"
            
        case .legal:
            iconName = "contract_icon_template"
            
        case .city:
            iconName = "earth_icon"
        }
        
        return UIImage(named: iconName)
    }
}
