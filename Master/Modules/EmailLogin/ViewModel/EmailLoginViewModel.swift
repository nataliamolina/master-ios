//
//  EmailLoginViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 11/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import EasyBinding

enum EmailLoginViewModelStatus {
    case loginReady
    case undefined
    case error(error: String?)
}

class EmailLoginViewModel {
    // MARK: - Properties
    let title = "emailLogin.title".localized
    let status = Var<EmailLoginViewModelStatus>(.undefined)
    let controlsEnabled = Var(true)
    let isLoading = Var(false)
    let service: EmailLoginServiceProtocol
    
    // MARK: - Life Cycle
    init(service: EmailLoginServiceProtocol? = nil) {
        let defaultService = EmailLoginService(connectionDependency: ConnectionManager())
        
        self.service = service ?? defaultService
        
        isLoading.valueDidChange = { [weak self] value in
            self?.controlsEnabled.value = !value
        }
    }
    
    // MARK: - Public Methods
    
    func login(email: String, password: String) {
        isLoading.value = true
        
        let request = LoginRequest(email: email, password: password)
        
        service.performLoginRequest(request: request) { [weak self] (response: LoginResponse?, error: CMError?) in
            self?.isLoading.value = false
            
            guard let authToken = response?.authToken, error == nil else {
                self?.status.value = .error(error: error?.localizedDescription)
                
                return
            }
            
            Session.shared.token = authToken
            self?.service.saveAuthenticationToken(authToken)
            self?.fetchUserInformation()
        }
    }
    
    // MARK: - Private Methods
    
    private func fetchUserInformation() {
        service.fetchUserSession { [weak self] (response: User?, error: CMError?) in
            self?.isLoading.value = false
            
            guard let user = response, error == nil else {
                self?.status.value = .error(error: error?.localizedDescription)
                
                return
            }
            
            self?.saveSessionWith(user: user)
            self?.status.value = .loginReady
        }
    }
    
    private func saveSessionWith(user: User) {
        Session.shared.profile = user.asUserProfile
    }
}
