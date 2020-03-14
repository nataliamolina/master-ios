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
    func postProviderRegister(request: ProviderRequest) {
        loadingState(true)
        
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
    
    func getListSelectorViewModel() -> ListSelectorViewModel {
        let bankTypes = [
            ListItem(value: "Cuenta de Ahorros", identifier: 0),
            ListItem(value: "Cuenta Corriente", identifier: 0),
            ListItem(value: "Otro", identifier: 0)
         ]
         
        return ListSelectorViewModel(title: nil, desc: "Selecciona tu tipo de cuenta", dataSource: bankTypes)
    }
    
    // MARK: - Private Methods
    
    private func loadingState(_ state: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading.value = state
        }
    }
}
