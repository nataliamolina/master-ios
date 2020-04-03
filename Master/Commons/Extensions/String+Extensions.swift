//
//  String+Extensions.swift
//  Master
//
//  Created by Carlos Mejía on 15/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

extension String {
    func replace(_ char: String, with: String) -> String {
        return self.replacingOccurrences(of: char, with: with)
    }
    
    var asDouble: Double {
        return Double(self) ?? 0
    }
    
    var asInt: Int {
        return Int(self) ?? 0
    }
}
