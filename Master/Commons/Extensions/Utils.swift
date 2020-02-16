//
//  Utils.swift
//  Master
//
//  Created by Carlos Mejía on 15/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

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
}
