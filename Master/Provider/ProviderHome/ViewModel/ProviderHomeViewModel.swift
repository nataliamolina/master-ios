//
//  ProviderHomeViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 14/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import EasyBinding

enum ProviderHomeViewModelStatus {
    case undefined
    case error(error: String?)
    case providerProfileLoaded(name: String)
}

private enum Sections: Int {
    case header
    case buttons
    case list
}

class ProviderHomeViewModel {
    // MARK: - Properties
    private var ordersDataSource = [ProviderOrderCellViewModel]()
    private var providerServicesDataSource = [ProviderServiceCellViewModel]()
    private let provider: ProviderProfile
    
    let status = Var<ProviderHomeViewModelStatus>(.undefined)
    let isLoading = Var(false)
    let dataSource: Var<[[CellViewModelProtocol]]> = Var([])
    
    private let service: ProviderHomeServiceProtocol
    
    // MARK: - Life Cycle
    init(provider: ProviderProfile, service: ProviderHomeServiceProtocol? = nil) {
        let defaultService = ProviderHomeService(connectionDependency: ConnectionManager())
        
        self.provider = provider
        self.service = service ?? defaultService
    }
    
    // MARK: - Public Methods
    
    func fetchProfile() {
        status.value = .providerProfileLoaded(name: provider.user.firstName)
        providerModelToViewModel(provider)
        
        fetchProviderServices()
    }
    
    func getViewModelAt(indexPath: IndexPath) -> CellViewModelProtocol? {
        return dataSource.value.safeContains(indexPath.section)?.safeContains(indexPath.row)
    }
    
    func toggleCommentsSection(with index: Int) {
        let section = dataSource.value[Sections.buttons.rawValue].first
        
        guard var buttonsViewModel = section as? SelectorCellViewModel else {
            return
        }
        
        buttonsViewModel.buttons.indices.forEach {
            buttonsViewModel.buttons[$0].style = index == $0 ? .green : .greenBorder
        }
        
        dataSource.value[Sections.buttons.rawValue] = [buttonsViewModel]
        
        if index == 1 {
            setOrdersDataSource()
        } else {
            setProviderServicesDataSource()
        }
    }
    
    // MARK: - Private Methods
    
    private func setOrdersDataSource() {
        dataSource.value[Sections.list.rawValue] = ordersDataSource
    }
    
    private func setProviderServicesDataSource() {
        dataSource.value[Sections.list.rawValue] = providerServicesDataSource
    }
    
    private func fetchProviderServices() {
        service.fetchProviderServices { [weak self] (response: [ProviderService], error: CMError?) in
            
            guard error == nil else {
                self?.isLoading.value = false
                
                return
            }
            
            self?.servicesToViewModels(models: response)
            self?.fetchProviderOrders()
        }
    }
    
    private func fetchProviderOrders() {
        service.fetchProviderOrders { [weak self] (response: [Order], error: CMError?) in
            
            guard error == nil else {
                self?.isLoading.value = false
                
                return
            }
            
            self?.ordersToViewModels(models: response)
        }
    }
    
    private func providerModelToViewModel(_ provider: ProviderProfile) {
        let names = provider.user.firstName + " " + provider.user.lastName
        
        let profileViewModel = ProviderProfileCellViewModel(photoUrl: provider.photoUrl ?? "",
                                                            names: names,
                                                            description: provider.description)
        
        dataSource.value = [[profileViewModel]]
        dataSource.value.append([getButtonsCellViewModel()])
    }
    
    private func getButtonsCellViewModel() -> SelectorCellViewModel {
        return SelectorCellViewModel(buttons: [
            SelectorCellButton(style: .green, title: "general.services".localized),
            SelectorCellButton(style: .greenBorder, title: "general.orders".localized)
        ])
    }
    
    private func servicesToViewModels(models: [ProviderService]) {
        providerServicesDataSource = models.map {
            ProviderServiceCellViewModel(productImageUrl: $0.photoUrl ?? "",
                                         productName: $0.name,
                                         productDesc: $0.description,
                                         productPrice: $0.price,
                                         productCount: 0,
                                         productId: $0.getId())
        }
        
        dataSource.value.append(providerServicesDataSource)
    }
    
    private func ordersToViewModels(models: [Order]) {
        ordersDataSource = models.map {
            ProviderOrderCellViewModel(id: $0.id.asString,
                                       userName: $0.user.names,
                                       orderCategory: $0.serviceCategory?.name ?? "",
                                       orderState: $0.orderState.type,
                                       isLastItem: $0.id == models.last?.id)
        }
        
        dataSource.value.append(ordersDataSource)
    }
}
