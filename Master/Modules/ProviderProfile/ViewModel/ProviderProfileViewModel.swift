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
    let userId: Int
    let categoryId: Int
    let status = Var<ProviderProfileViewModelStatus>(.undefined)
    let isLoading = Var(false)
    let dataSource: Var<[CellViewModelProtocol]> = Var([])
    
    private(set) var sectionTitles = [String]()
    private let service: ProviderProfileServiceProtocol
    
    // MARK: - Life Cycle
    init(userId: Int, categoryId: Int, service: ProviderProfileServiceProtocol? = nil) {
        let defaultService = ProviderProfileService(connectionDependency: ConnectionManager())
        
        self.categoryId = categoryId
        self.userId = userId
        self.service = service ?? defaultService
    }
    
    // MARK: - Public Methods
    
    func fetchProfile() {
        isLoading.value = true
        
        service.fetchProfile(userId: userId) { [weak self] (response: Provider?, error: CMError?) in
            
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
        service.fetchProviderServices(providerId: userId, categoryId: categoryId) { [weak self] (response: [ProviderService]?, error: CMError?) in
            
            guard let models = response, error == nil else {
                self?.isLoading.value = false
                
                return
            }
            
            self?.servicesToViewModels(models: models)
        }
    }
    
    private func fetchProviderComments() {
        service.fetchComments(providerId: userId) { [weak self] (response: CommentsResponse?, error: CMError?) in
            
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
        
    }
}
