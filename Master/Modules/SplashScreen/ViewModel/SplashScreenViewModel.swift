//
//  SplashScreenViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 12/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import SimpleBinding

enum SplashScreenViewModelStatus {
    case preloadReady(hasSession: Bool)
    case undefined
    case error(error: String?)
}

class SplashScreenViewModel {
    // MARK: - Properties
    let status = Var<SplashScreenViewModelStatus>(.undefined)
    let isLoading = Var(false)
    let service: SplashScreenServiceProtocol
    
    // MARK: - Life Cycle
    init(service: SplashScreenServiceProtocol? = nil) {
        let defaultService = SplashScreenService(connectionDependency: ConnectionManager())
        
        self.service = service ?? defaultService
    }
    
    func fetchRequiredServices() {
        isLoading.value = true
        checkServerStatus()
    }
    
    // MARK: - Private Methods
    
    private func checkServerStatus() {
        service.checkServerStatus { [weak self] (response: ServerStatus?, error: Error?) in
            self?.isLoading.value = false
            
            if response?.isOnline == true {
                self?.validateTokenIfNeeded()
                
                return
            }
            
            self?.status.value = .error(error: response?.offlineMessage ?? error?.localizedDescription)
        }
    }
    
    private func validateTokenIfNeeded() {
        guard Session.shared.token != nil else {
            status.value = .preloadReady(hasSession: false)
            
            return
        }
        
        service.checkSessionToken { [weak self] (response: ServerResponse<Bool>?, error: Error?) in
            self?.isLoading.value = false
            
            if response?.data == true {
                self?.fetchUserInformation()
                
                return
            }
            
            self?.status.value = .error(error: response?.userErrorMessage ?? error?.localizedDescription)
        }
    }
    
    private func fetchUserInformation() {
        service.fetchUserSession { [weak self] (response: User?, error: Error?) in
            self?.isLoading.value = false
            
            guard let user = response, error == nil else {
                self?.status.value = .error(error: error?.localizedDescription)
                
                return
            }
            
            // TODO: Save user session
            self?.status.value = .preloadReady(hasSession: true)
        }
    }
}
