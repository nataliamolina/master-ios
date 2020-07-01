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
    case providerProfileLoaded(name: String)
}

private enum Sections: Int {
    case header
    case buttons
    case list
}

class ProviderProfileViewModel {
    // MARK: - Properties
    private let providerUserId: Int
    private let providerId: Int
    private let categoryId: Int
    private var commentsDataSource = [CommentCellViewModel]()
    private var providerServicesDataSource = [ProviderServiceCellViewModel]()
    
    let average: Var<Double> = Var(0)
    let status = Var<ProviderProfileViewModelStatus>(.undefined)
    let isLoading = Var(false)
    let dataSource: Var<[[CellViewModelProtocol]]> = Var([])
    let formattedTotal = Var("$0")
    
    private(set) var total: Double = 0 {
        didSet {
            formattedTotal.value = total.toFormattedCurrency(withSymbol: true)
        }
    }
    
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
            
            self?.status.value = .providerProfileLoaded(name: model.user.names)
            self?.providerModelToViewModel(model)
            self?.fetchProviderServices()
        }
    }
    
    func getViewModelAt(indexPath: IndexPath) -> CellViewModelProtocol? {
        return dataSource.value.safeContains(indexPath.section)?.safeContains(indexPath.row)
    }
    
    func getViewModelForCheckout() -> CheckoutViewModel? {
        guard
            let providerViewModel = dataSource.value[Sections.header.rawValue].first as? ProviderProfileCellViewModel,
            let cart = dataSource.value[Sections.list.rawValue] as? [ProviderServiceCellViewModel] else {
            return nil
        }
        
        let checkoutProvider = CheckoutProvider(id: providerId,
                                                names: providerViewModel.names,
                                                photoUrl: providerViewModel.photoUrl,
                                                description: providerViewModel.description)
        
        return CheckoutViewModel(provider: checkoutProvider,
                                 cart: cart.filter { $0.productCount > 0 },
                                 categoryId: categoryId)
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
            
        } else {
            
        }
        
        switch index {
        case 0:
            setProviderServicesDataSource()
        case 1:
            setInfoProvider()
        case 2:
            setCommentsDataSource()
        default:
            break
        }
    }
    
    func updateTotalForItem(identifier: String, total: Int) {
        let index = dataSource.value[Sections.list.rawValue].firstIndex {
            ($0 as? ProviderServiceCellViewModel)?.getIdentifier() == identifier
        }
        
        if let index = index, let providerService = dataSource.value[Sections.list.rawValue][index] as? ProviderServiceCellViewModel {
            providerService.productCount = total
            dataSource.value[Sections.list.rawValue][index] = providerService
        }
        
        updateTotal()
    }
    
    // MARK: - Private Methods
    
    private func updateTotal() {
        var total: Double = 0
        
        dataSource.value[Sections.list.rawValue].forEach {
            guard let item = ($0 as? ProviderServiceCellViewModel), item.productCount > 0 else {
                return
            }
            
            total += item.totalPrice
        }
        
        self.total = total
    }
    
    private func setCommentsDataSource() {
        dataSource.value[Sections.list.rawValue] = commentsDataSource
    }
    
    private func setProviderServicesDataSource() {
        dataSource.value[Sections.list.rawValue] = providerServicesDataSource
    }
    
    private func setInfoProvider() {
        dataSource.value[Sections.list.rawValue] = providerServicesDataSource
    }
    
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
        service.fetchComments(providerId: providerId) { [weak self] (response: CommentsResponse?, error: CMError?) in
            self?.isLoading.value = false
            
            guard let model = response, error == nil else {
                self?.isLoading.value = false
                
                return
            }
            
            self?.commentsToViewModel(model)
        }
    }
    
    private func commentsToViewModel(_ model: CommentsResponse) {
        average.value = model.average.rounded(toPlaces: 1)
        
        commentsDataSource = model.comments.map {
            CommentCellViewModel(authorImageUrl: $0.author.imageUrl,
                                 authorNames: $0.author.names,
                                 authorMessage: $0.text,
                                 authorScore: $0.score,
                                 isLastItem: $0.id == model.comments.last?.id)
        }
    }
    
    private func providerModelToViewModel(_ provider: Provider) {
        let names = provider.user.firstName + " " + provider.user.lastName
        
        let profileViewModel = ProviderProfileCellViewModel(photoUrl: provider.photoUrl,
                                                            names: names,
                                                            description: provider.description)
        
        dataSource.value = [[profileViewModel]]
        dataSource.value.append([getButtonsCellViewModel()])
    }
    
    private func getButtonsCellViewModel() -> SelectorCellViewModel {
        return SelectorCellViewModel(buttons: [
            SelectorCellButton(style: .green, title: "general.services".localized),
            SelectorCellButton(style: .greenBorder, title: "general.info".localized),
            SelectorCellButton(style: .greenBorder, title: "general.comments".localized)
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
}
