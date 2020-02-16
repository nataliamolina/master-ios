//
//  ProviderProfileViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 16/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import EasyBinding

enum ProviderProfileViewModelStatus {
    case undefined
    case error(error: String?)
}

class ProviderProfileViewModel {
    // MARK: - Properties
    private let providerUserId: Int
    private let providerId: Int
    private let categoryId: Int
    let status = Var<ProviderProfileViewModelStatus>(.undefined)
    let isLoading = Var(false)
    let dataSource: Var<[CellViewModelProtocol]> = Var([])
    
    private(set) var sectionTitles = [String]()
    private let service: ProviderProfileServiceProtocol
    
    // MARK: - Life Cycle
    init(providerUserId: Int, categoryId: Int, providerId: Int, service: ProviderProfileServiceProtocol? = nil) {
        let defaultService = ProviderProfileService(connectionDependency: ConnectionManager())
        
        self.providerId = providerId
        self.categoryId = categoryId
        self.providerUserId = providerUserId
        self.service = service ?? defaultService
    }
    
    // MARK: - Public Methods
    
    func fetchProfile() {
        isLoading.value = true
        
        service.fetchProfile(userId: providerUserId) { [weak self] (response: Provider?, error: CMError?) in
            
            guard let model = response, error == nil else {
                self?.isLoading.value = false
                
                self?.status.value = .error(error: error?.localizedDescription)
                
                return
            }
            
            self?.providerModelToViewModel(model)
            self?.fetchProviderServices()
        }
    }
    
    func getViewModelAt(indexPath: IndexPath) -> CellViewModelProtocol? {
        return dataSource.value.safeContains(indexPath.row)
    }
    
    // MARK: - Private Methods
    
    private func fetchProviderServices() {
        service.fetchProviderServices(providerId: providerId, categoryId: categoryId) { [weak self] (response: [ProviderService]?, error: CMError?) in
            
            guard let models = response, error == nil else {
                self?.isLoading.value = false
                
                return
            }
            
            self?.servicesToViewModels(models: models)
            self?.fetchProviderComments()
        }
    }
    
    private func fetchProviderComments() {
        service.fetchComments(providerId: providerUserId) { [weak self] (response: CommentsResponse?, error: CMError?) in
            self?.isLoading.value = false
            
            guard let model = response, error == nil else {
                self?.isLoading.value = false
                
                return
            }
            
            self?.commentsToViewModel(model)
        }
    }
    
    private func commentsToViewModel(_ model: CommentsResponse) {
        
    }
    
    private func providerModelToViewModel(_ provider: Provider) {
        let names = provider.user.firstName + " " + provider.user.lastName
        
        let profileViewModel = ProviderProfileCellViewModel(photoUrl: provider.photoUrl,
                                                            names: names,
                                                            description: provider.description)
        
        dataSource.value.append(profileViewModel)
    }
    
    private func servicesToViewModels(models: [ProviderService]) {
        let viewModels = models.map {
            ProviderServiceCellViewModel(productImageUrl: $0.photoUrl ?? "",
                                         productName: $0.name,
                                         productDesc: $0.description,
                                         productPrice: $0.price,
                                         productCount: 0)
        }
        
        dataSource.value.append(contentsOf: viewModels)
    }
}
