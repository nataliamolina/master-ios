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
    private var cityDataSource = [ListItem]()
    private let cityService: CitySelectorServiceProtocol
    private let service: ProviderRegisterServiceProtocol
    
    let status = Var<ProviderRegisterViewModelStatus>(.undefined)
    let isLoading = Var(false)
    
    var citySelectedId: Int?

    // MARK: - Life Cycle
    init(service: ProviderRegisterServiceProtocol? = nil,
         cityService: CitySelectorServiceProtocol? = nil) {
        
        let defaultService = ProviderRegisterService(connectionDependency: ConnectionManager())
        let defaulCitytService = CitySelectorService(connectionDependency: ConnectionManager())
        
        self.service = service ?? defaultService
        self.cityService = cityService ?? defaulCitytService
        
        fetchCityList()
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
            ListItem(value: "Cuenta Corriente", identifier: 1),
            ListItem(value: "Otro", identifier: 2)
         ]
         
        return ListSelectorViewModel(title: nil,
                                     desc: "Selecciona tu tipo de cuenta",
                                     dataSource: bankTypes,
                                     identifier: ProviderRegisterIdentifiers.bankType.rawValue)
    }
    
    func getCityListSelectorViewModel() -> ListSelectorViewModel {
        return ListSelectorViewModel(title: nil,
                                     desc: "Selecciona una ciudad",
                                     dataSource: cityDataSource,
                                     identifier: ProviderRegisterIdentifiers.city.rawValue)
    }
       
    func getCompleteTextViewModel(savedValue: String?) -> CompleteTextViewModel {
        // FIXME: Strings
        return CompleteTextViewModel(title: "provider.register.about".localized,
                                     desc: "provider.register.aboutPlaceholder".localized,
                                     placeholder: "",
                                     index: 0,
                                     savedValue: savedValue)
    }
    
    // MARK: - Private Methods
    
    private func fetchCityList() {
        loadingState(true)

        cityService.fetchCities { [weak self] (response: [City], _) in
            self?.loadingState(false)

            self?.cityDataSource = response.map {
                ListItem(value: $0.name, identifier: $0.id)
            }
        }
    }
    
    private func loadingState(_ state: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading.value = state
        }
    }
}
