//
//  Session.swift
//  Master
//
//  Created by Carlos Mejía on 12/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn

enum SessionKeys: String {
    case sessionToken
}

class Session {
    // MARK: - Properties
    private let service: SessionServiceProtocol = SessionService(connectionDependency: ConnectionManager())
    private let storage: AppStorageProtocol = AppStorage()
    static let shared = Session()
    
    var helpUrl: String = ""
    var provider: ProviderProfile?
    private(set) var profile: UserProfile = .empty

    var token: String? {
        set(newValue) {
            newValue != nil ?
                storage.save(value: newValue ?? "", key: SessionKeys.sessionToken.rawValue) :
                storage.delete(key: SessionKeys.sessionToken.rawValue)
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
    func login(profile: UserProfile) {
        updatePushToken()
        
        self.profile = profile
    }
    
    func logout() {
        logoutInServerSide()
        GIDSignIn.sharedInstance()?.signOut()
        token = nil
        profile = .empty
    }
    
    // MARK: - Private Methods
        
    private func updatePushToken() {
        InstanceID.instanceID().instanceID { [weak self] (result, _) in
            guard let token = result?.token else {
                return
            }
            
            self?.service.updatePushToken(token, onComplete: {_, _ in})
        }
    }
    
    private func logoutInServerSide() {
        service.logout(onComplete: nil)
    }
}
