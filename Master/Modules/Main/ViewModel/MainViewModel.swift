//
//  MainViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 13/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import EasyBinding

enum MainViewModelStatus {
    case gmailLoginReady
    case undefined
    case error(error: String?)
}

class MainViewModel {
    // MARK: - Properties
    let googleClientID = "693225996301-dfpnfbpnkv5p7tomsdh69u94afuud6mt.apps.googleusercontent.com"
    let videoName = "login_bg_video_new"
    let videoExtension = "mp4"
    let status = Var<MainViewModelStatus>(.undefined)
    let controlsEnabled = Var(true)
    let isLoading = Var(false)
    
    private let service: EmailLoginServiceProtocol
    
    // MARK: - Life Cycle
    init(service: EmailLoginServiceProtocol? = nil) {
        let defaultService = EmailLoginService(connectionDependency: ConnectionManager())
        
        self.service = service ?? defaultService
        
        isLoading.valueDidChange = { [weak self] value in
            self?.controlsEnabled.value = !value
        }
    }
    
    // MARK: - Public Methods
    
    func gmailLogin(photoUrl: String, id: String,
                    gmailToken: String, email: String,
                    firstName: String, lastName: String) {
        
        isLoading.value = true
        
        let request = GmailRequest(platformId: 1,
                                   photoUrl: photoUrl,
                                   id: id,
                                   gmailToken: gmailToken,
                                   email: email,
                                   firstName: firstName,
                                   lastName: lastName)
        
        service.performGmailRequest(request: request) { [weak self] (response: LoginResponse?, error: CMError?) in
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
            self?.status.value = .gmailLoginReady
        }
    }
    
    private func saveSessionWith(user: User) {
        Session.shared.profile = user.asUserProfile
    }
}
