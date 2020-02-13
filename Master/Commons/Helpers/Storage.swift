//
//  Storage.swift
//  Master
//
//  Created by Carlos Mejía on 12/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol StorageProtocol {
    func get<T>(key: String) -> T?
    func save<T>(value: T, key: String)
    func update<T>(value: T, key: String)
    func delete(key: String)
}

// FIXME: Use keychain!
class Storage: StorageProtocol {
    private let defaults = UserDefaults.standard
    
    func get<T>(key: String) -> T? {
        return defaults.object(forKey: key) as? T
    }
    
    func update<T>(value: T, key: String) {
        defaults.removeObject(forKey: key)
        
        save(value: value, key: key)
    }
    
    func save<T>(value: T, key: String) {
        defaults.set(value, forKey: key)
    }
    
    func delete(key: String) {
        defaults.removeObject(forKey: key)
    }
}
