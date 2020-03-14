//
//  ProviderRegisterViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 14/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import EasyBinding

enum ProviderRegisterViewModelStatus {
    case undefined
    case error(error: String?)
    case registerDone
}

class ProviderRegisterViewModel {
    // MARK: - Properties
    private let service: ProviderRegisterServiceProtocol
    
    let status = Var<ProviderRegisterViewModelStatus>(.undefined)
    let isLoading = Var(false)
    
    // MARK: - Life Cycle
    init(service: ProviderRegisterServiceProtocol = ProviderRegisterService(connectionDependency: ConnectionManager())) {
        self.service = service
    }
    
    // MARK: - Public Methods
    func postProviderRegister(nickName: String, photoUrl: String,
                              description: String, document: String,
                              bankAccountNumber: String, bankAccountType: String,
                              bankName: String) {
        loadingState(true)
        
        let request = ProviderRequest(nickName: nickName,
                                      photoUrl: photoUrl,
                                      description: description,
                                      document: document,
                                      bankAccountNumber: bankAccountNumber,
                                      bankAccountType: bankAccountType,
                                      bankName: bankName)
        
        service.createProvider(request: request) { [weak self] (provider: Provider?, error: CMError?) in
            self?.loadingState(false)
            
            guard let provider = provider else {
                self?.status.value = .error(error: error?.error)

                return
            }
            
            Session.shared.provider = provider.asProviderProfile
            self?.status.value = .registerDone
        }
    }
    
    // MARK: - Private Methods
    
    private func loadingState(_ state: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading.value = state
        }
    }
}
