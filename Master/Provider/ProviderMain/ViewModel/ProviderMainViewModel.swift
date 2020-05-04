//
//  ProviderMainViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 14/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import EasyBinding

enum ProviderMainViewModelStatus {
    case undefined
    case error(error: String?)
    case needToCreateProviderAccount
    case providerProfileLoaded
    case needsToUploadPhoto
}

class ProviderMainViewModel {
    // MARK: - Properties
    enum Keys: String {
        case providerWelcome
    }
    
    private let service: ProviderMainServiceProtocol
    private let storageService: AppStorageProtocol

    let status = Var<ProviderMainViewModelStatus>(.undefined)
    let isLoading = Var(false)
    
    var isOnBoardingRequired: Bool {
        let result: Bool? = storageService.get(key: Keys.providerWelcome.rawValue)
        
        return result == nil
    }
    
    // MARK: - Life Cycle
    init(service: ProviderMainServiceProtocol = ProviderMainService(connectionDependency: ConnectionManager()),
         storageService: AppStorageProtocol = AppStorage()) {
        
        self.storageService = storageService
        self.service = service
    }
    
    // MARK: - Public Methods
    func getProviderProfile() {
        loadingState(true)
        
        service.getProviderProfile { [weak self] (response: Provider?, error: CMError?) in
            self?.loadingState(false)
            
            if let error = error {
                self?.status.value = .error(error: error.error)
                
                return
            }
            
            self?.handleProfileResult(response)
        }
    }
    
    // MARK: - Private Methods
    private func handleProfileResult(_ result: Provider?) {
        guard let profile = result else {
            status.value = .needToCreateProviderAccount
            
            return
        }
        
        Session.shared.provider = profile.asProviderProfile
        
        if profile.photoUrl.isEmpty {
            status.value = .needsToUploadPhoto
        } else {
            status.value = .providerProfileLoaded
        }
    }
    
    private func loadingState(_ state: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading.value = state
        }
    }
}
