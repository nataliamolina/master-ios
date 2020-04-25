//
//  ProviderListViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 15/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit
import EasyBinding

enum ProviderListViewModelStatus {
    case undefined
    case error(error: String?)
    case emptyStateRequired
}

class ProviderListViewModel {
    // MARK: - Properties
    private let storageService: AppStorageProtocol
    private let serviceId: Int
    
    let serviceImageUrl: String?
    let status = Var<ProviderListViewModelStatus>(.undefined)
    let isLoading = Var(false)
    let dataSource = Var<[CellViewModelProtocol]>([])

    private var currentCityId: Int {
        let result: Int? = storageService.get(key: CitySelectorViewModel.Keys.cityId.rawValue)
        
        return result ?? 1
    }
    
    private let service: ProviderListServiceProtocol
    
    // MARK: - Life Cycle
    init(serviceId: Int, serviceImageUrl: String?,
         service: ProviderListServiceProtocol? = nil,
         storageService: AppStorageProtocol? = nil) {
        
        let defaultService = ProviderListService(connectionDependency: ConnectionManager())
        
        self.serviceImageUrl = serviceImageUrl
        self.serviceId = serviceId
        self.service = service ?? defaultService
        self.storageService = storageService ?? AppStorage()
    }
    
    // MARK: - Public Methods
    
    func fetchDetail() {
        isLoading.value = true
        
        service.fetchServiceDetailById(serviceId, cityId: currentCityId) { [weak self] (response: [ProviderWithScore]?, error: CMError?) in
            self?.isLoading.value = false
            
            guard let models = response, error == nil else {
                self?.status.value = .error(error: error?.localizedDescription)
                
                return
            }
            
            if models.isEmpty {
                self?.status.value = .emptyStateRequired
                
                return
            }
            
            self?.servicesToViewModels(models: models)
        }
    }
    
    func getProviderProfileViewModelAt(indexPath: IndexPath) -> ProviderProfileViewModel? {
          guard let selectedProvider = getViewModelAt(indexPath: indexPath) else {
              return nil
          }
        
        return ProviderProfileViewModel(providerUserId: selectedProvider.providerUserId,
                                        categoryId: serviceId,
                                        providerId: selectedProvider.providerId)
      }
      
    func getViewModelAt(indexPath: IndexPath) -> ProviderCellViewModel? {
        return dataSource.value.safeContains(indexPath.row) as? ProviderCellViewModel
    }
    
    // MARK: - Private Methods
    
    private func servicesToViewModels(models: [ProviderWithScore]) {
        dataSource.value = models.map {
            ProviderCellViewModel(providerUserId: $0.userId,
                                  providerId: $0.id,
                                  imageUrl: $0.photoUrl,
                                  names: $0.names,
                                  score: $0.score,
                                  desc: $0.description,
                                  totalOrders: $0.totalOrders,
                                  isLastItem: models.last?.id == $0.id)
        }
    }
}
