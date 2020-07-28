//
//  ProviderEditViewModel.swift
//  Master
//
//  Created by Maria Paula Gomez Prieto on 7/22/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import EasyBinding

enum ProviderEditViewModelStatus {
    case undefined
    case error(error: String?)
    case editDone
}

class ProviderEditViewModel {
    // MARK: - Properties
    private var cityDataSource = [ListItem]()
    private let cityService: CitySelectorServiceProtocol
    private let service: ProviderRegisterServiceProtocol
    
    let status = Var<ProviderEditViewModelStatus>(.undefined)
    let isLoading = Var(false)
    let document = Var("")
    let about = Var("")
    let city = Var("")
    let banck = Var("")
    let banckNumber = Var("")
    let banckType = Var("")
    
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
    func putProviderEdit(request: ProviderEditRequest) {
        loadingState(true)
        
        service.editProvider(request: request) { [weak self] (provider: Provider?, error: CMError?) in
            self?.loadingState(false)
            
            guard let provider = provider else {
                self?.status.value = .error(error: error?.error)

                return
            }
            
            Session.shared.login(profile: provider.user.asUserProfile)
            Session.shared.provider = provider.asProviderProfile
            self?.status.value = .editDone
        }
    }
    
    func getPhotoUrl() -> String {
        return Session.shared.provider?.photoUrl ?? ""
    }
    
    func getProvider() -> ProviderProfile? {
       return Session.shared.provider
    }
    
    func setValues() {
        document.value = Session.shared.provider?.user.document ?? ""
        about.value = Session.shared.provider?.description ?? ""
        city.value = Session.shared.provider?.city?.name ?? ""
        banck.value = Session.shared.provider?.bankName ?? ""
        banckNumber.value = Session.shared.provider?.bankAccountNumber ?? ""
        banckType.value = Session.shared.provider?.bankAccountType ?? ""
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
