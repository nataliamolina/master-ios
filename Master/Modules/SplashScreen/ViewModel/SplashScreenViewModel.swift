//
//  SplashScreenViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 12/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import EasyBinding

enum SplashScreenViewModelStatus {
    case preloadReady(hasSession: Bool)
    case tokenExpired
    case undefined
    case error(error: String?)
}

class SplashScreenViewModel {
    // MARK: - Properties
    let status = Var<SplashScreenViewModelStatus>(.undefined)
    let service: SplashScreenServiceProtocol
    let loginService: EmailLoginServiceProtocol
    
    // MARK: - Life Cycle
    init(service: SplashScreenServiceProtocol? = nil, loginService: EmailLoginServiceProtocol? = nil) {
        let connectionManager = ConnectionManager()
        
        let defaultService = SplashScreenService(connectionDependency: connectionManager)
        let defaultLoginService = EmailLoginService(connectionDependency: connectionManager)
        
        self.service = service ?? defaultService
        self.loginService = loginService ?? defaultLoginService
    }
    
    func fetchRequiredServices() {
        checkServerStatus()
    }
    
    // MARK: - Private Methods
    
    private func checkServerStatus() {
        service.checkServerStatus { [weak self] (response: ServerStatus?, error: CMError?) in
            
            if response?.isOnline == true {
                self?.validateTokenIfNeeded()
                
                return
            }
            
            self?.status.value = .error(error: response?.offlineMessage ?? error?.localizedDescription)
        }
    }
    
    private func validateTokenIfNeeded() {
        guard let token = Session.shared.token, !token.isEmpty else {
            status.value = .preloadReady(hasSession: false)
            
            return
        }
        
        loginService.saveAuthenticationToken(token)
        
        service.checkSessionToken { [weak self] (response: Bool, error: CMError?) in
            
            if response {
                self?.fetchUserInformation()
                
                return
            } else {
                Session.shared.logout()
                self?.status.value = .tokenExpired
            }
            
            self?.status.value = .error(error: error?.localizedDescription)
        }
    }
    
    private func fetchUserInformation() {
        loginService.fetchUserSession { [weak self] (response: User?, error: CMError?) in
            
            guard let user = response, error == nil else {
                Session.shared.logout()
                self?.status.value = .tokenExpired
                
                return
            }
            
            Session.shared.profile = user.asUserProfile
            self?.status.value = .preloadReady(hasSession: true)
        }
    }
}
