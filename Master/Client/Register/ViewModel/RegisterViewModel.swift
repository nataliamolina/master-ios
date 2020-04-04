//
//  RegisterViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 13/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import EasyBinding

enum RegisterViewModelStatus {
    case registerReady
    case undefined
    case error(error: String?)
}

class RegisterViewModel {
    // MARK: - Properties
    let title = "register.title".localized
    let status = Var<RegisterViewModelStatus>(.undefined)
    let controlsEnabled = Var(true)
    let isLoading = Var(false)
    
    private let service: RegisterServiceProtocol
    private let loginService: EmailLoginServiceProtocol
    
    // MARK: - Life Cycle
    init(service: RegisterServiceProtocol? = nil, loginService: EmailLoginServiceProtocol? = nil) {
        let defaultService = RegisterService(connectionDependency: ConnectionManager())
        let defaultLoginService = EmailLoginService(connectionDependency: ConnectionManager())
        
        self.loginService = loginService ?? defaultLoginService
        self.service = service ?? defaultService
        
        isLoading.listen { [weak self] value in
            self?.controlsEnabled.value = !value
        }
    }
    
    // MARK: - Public Methods
    
    func register(email: String, password: String, firstName: String, lastName: String, phoneNumber: String) {
        isLoading.value = true
        
        let request = RegisterRequest(imageUrl: "",
                                      email: email,
                                      password: password,
                                      firstName: firstName,
                                      lastName: lastName,
                                      phoneNumber: phoneNumber,
                                      document: "")
        
        service.performRegister(request: request) { [weak self] (response: LoginResponse?, error: CMError?) in
            self?.isLoading.value = false
            
            guard let authToken = response?.authToken, error == nil else {
                self?.status.value = .error(error: error?.localizedDescription)
                
                return
            }
            
            Session.shared.token = authToken
            self?.loginService.saveAuthenticationToken(authToken)
            self?.fetchUserInformation()
        }
    }
    
    // MARK: - Private Methods
    
    private func fetchUserInformation() {
        loginService.fetchUserSession { [weak self] (response: User?, error: CMError?) in
            self?.isLoading.value = false
            
            guard let user = response, error == nil else {
                self?.status.value = .error(error: error?.localizedDescription)
                
                return
            }
            
            self?.saveSessionWith(user: user)
            self?.status.value = .registerReady
        }
    }
    
    private func saveSessionWith(user: User) {
        Session.shared.login(profile: user.asUserProfile)
    }
}
