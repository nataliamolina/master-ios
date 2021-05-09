//
//  File.swift
//  Master
//
//  Created by Maria Paula Gomez Prieto on 7/6/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import UIKit

public extension Date {
    func toString() -> String {
        return toString(format: String.FormatDate.universalFormat)
    }
    
    func toString(format: String, locale: Locale = .current) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = locale
        return formatter.string(from: self)
    }
    
    var asJson: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        return dateFormatter.string(from: Date())
    }
}
