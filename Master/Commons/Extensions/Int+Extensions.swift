//
//  Int+Extensions.swift
//  Master
//
//  Created by Carlos Mejía on 16/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

extension Double {
    var asString: String {
        return "\(self)"
    }
    
    func toFormattedCurrency(withSymbol: Bool = true) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "es_CO")

        var result = formatter.string(from: NSNumber(value: self)) ?? ""
        
        if !withSymbol {
            result = result.replace("$", with: "")
        }
        
        return result
    }
}

extension Int {
    var asString: String {
        return "\(self)"
    }
}

extension Float {
    var asString: String {
        return "\(self)"
    }
}
