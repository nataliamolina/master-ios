//
//  MainViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 13/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import EasyBinding
import AuthenticationServices

enum MainViewModelStatus {
    case gmailLoginReady
    case undefined
    case error(error: String?)
}

class MainViewModel: NSObject {
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
        
        super.init()
        
        setupControlState()
    }
    
    // MARK: - Public Methods
    
    func gmailLogin(photoUrl: String, id: String,
                    gmailToken: String, email: String,
                    names: (first: String, last: String)) {
        
        isLoading.value = true
        
        let request = GmailRequest(photoUrl: photoUrl,
                                   id: id,
                                   gmailToken: gmailToken,
                                   email: email,
                                   firstName: names.first,
                                   lastName: names.last)
        
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
    
    @available(iOS 13.0, *)
    func getAppleAuthorizationRequest() -> ASAuthorizationAppleIDRequest {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        
        request.requestedScopes = [.fullName, .email]
        
        return request
    }
    
    // MARK: - Private Methods
    
    private func setupControlState() {
        isLoading.listen { [weak self] value in
            self?.controlsEnabled.value = !value
        }
    }
    
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
    
    private func loginWithAppleId(id: String, firstName: String, lastName: String, email: String) {
        isLoading.value = true
        
        let request = AppleSignInRequest(id: id, email: email, firstName: firstName, lastName: lastName)
        
        service.performAppleSignInRequest(request: request) { [weak self] (response: LoginResponse?, error: CMError?) in
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
}

// MARK: - ASAuthorizationControllerDelegate
@available(iOS 13.0, *)
extension MainViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        
        isLoading.value = false
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
        }
        
        let fullName = appleIDCredential.fullName ?? PersonNameComponents()
        let email = appleIDCredential.email ?? ""
        
        loginWithAppleId(id: appleIDCredential.user,
                         firstName: fullName.givenName ?? "",
                         lastName: fullName.familyName ?? "",
                         email: email)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        isLoading.value = false
    }
}
