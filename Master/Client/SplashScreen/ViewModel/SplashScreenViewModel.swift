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
    case preloadReady
    case tokenExpired
    case undefined
    case needSelectCity
    case needShowsTutorial
    case error(error: String?)
}

class SplashScreenViewModel {
    // MARK: - Properties
    enum Keys: String {
        case welcome
    }
    
    let status = Var<SplashScreenViewModelStatus>(.undefined)
    
    private let service: SplashScreenServiceProtocol
    private let loginService: EmailLoginServiceProtocol
    private let storedData: AppStorageProtocol
    
    private var needsToSelectCity: Bool {
        let result: String? = storedData.get(key: CitySelectorViewModel.Keys.cityName.rawValue)
        
        return result == nil
    }
    
    private var needsToShowWelcome: Bool {
        let result: Bool? = storedData.get(key: Keys.welcome.rawValue) ?? true
        
        return result == true
    }
    
    // MARK: - Life Cycle
    init(service: SplashScreenServiceProtocol? = nil,
         loginService: EmailLoginServiceProtocol? = nil,
         storedData: AppStorageProtocol? = nil) {
        
        let connectionManager = ConnectionManager()
        
        let defaultStorageService = AppStorage()
        let defaultService = SplashScreenService(connectionDependency: connectionManager)
        let defaultLoginService = EmailLoginService(connectionDependency: connectionManager)
        
        self.service = service ?? defaultService
        self.loginService = loginService ?? defaultLoginService
        self.storedData = storedData ?? defaultStorageService
    }
    
    func fetchRequiredServices() {
        checkServerStatus()
    }
    
    func getCitySelectorViewModel() -> CitySelectorViewModel {
        return CitySelectorViewModel()
    }
    
    func getWelcomeViewModel() -> WelcomeViewModel {
        return WelcomeViewModel()
    }
    
    // MARK: - Private Methods
    
    private func checkServerStatus() {
        service.checkServerStatus { [weak self] (response: ServerStatus?, error: CMError?) in
            Session.shared.helpUrl = response?.helpUrl ?? ""
            
            if response?.isOnline == true {
                self?.validateTokenIfNeeded()
                
                return
            }
            
            self?.status.value = .error(error: response?.offlineMessage ?? error?.localizedDescription)
        }
    }
    
    private func validateTokenIfNeeded() {
        guard let token = Session.shared.token, !token.isEmpty else {
            resolveFinalRoute()
            
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
    
    private func resolveFinalRoute() {
        if self.needsToShowWelcome {
            status.value = .needShowsTutorial
            
            return
        }
        
        if self.needsToSelectCity {
            status.value = .needSelectCity
            
            return
        }
        
        status.value = .preloadReady
    }
    
    private func fetchUserInformation() {
        loginService.fetchUserSession { [weak self] (response: User?, error: CMError?) in
            guard let self = self else { return }
            
            guard let user = response, error == nil else {
                Session.shared.logout()
                self.status.value = .tokenExpired
                
                return
            }
            
            Session.shared.login(profile: user.asUserProfile)
            
            self.resolveFinalRoute()
        }
    }
}
