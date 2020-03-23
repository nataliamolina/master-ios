//
//  Utils.swift
//  Master
//
//  Created by Carlos Mejía on 15/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

typealias CompletionBlock = () -> Void

struct Utils {
    static var plist: NSDictionary? {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            return nil
        }
        
        return NSDictionary(contentsOfFile: path)
    }
    
    static var endpoints: NSDictionary? {
        guard let path = Bundle.main.path(forResource: "Endpoints", ofType: "plist") else {
            return nil
        }
        
        return NSDictionary(contentsOfFile: path)
    }
    
    static func jsonToFormattedDate(_ json: String) -> String {
        guard let date = stringToDate(json) else {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        
        return dateFormatter.string(from: date)
    }
    
    static func stringToDate(_ string: String, dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat

        let date: Date? = dateFormatter.date(from: string)
        
        return date
    }
}
