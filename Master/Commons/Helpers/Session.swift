//
//  Session.swift
//  Master
//
//  Created by Carlos Mejía on 12/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

enum SessionKeys: String {
    case sessionToken
}

class Session {
    // MARK: - Properties
    private let storage: AppStorageProtocol = AppStorage()
    static let shared = Session()
    
    var helpUrl: String = ""
    var profile: UserProfile = .empty
    var provider: ProviderProfile?
    
    var token: String? {
        set(newValue) {
            storage.save(value: newValue ?? "",
                         key: SessionKeys.sessionToken.rawValue)
        }
        get {
            let value: String? = storage.get(key: SessionKeys.sessionToken.rawValue)
            return value
        }
    }
    
    var isLoggedIn: Bool {
        return token?.isEmpty == false
    }
    
    // MARK: - Life Cycle
    private init() {}
    
    // MARK: - Public Methods
    func logout() {
        token = nil
        profile = .empty
    }
    
    // MARK: - Private Methods
}
