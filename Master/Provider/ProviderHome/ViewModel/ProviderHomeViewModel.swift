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
    case title
    case list
    case secondTitle
    case secondList
}

class ProviderHomeViewModel {
    // MARK: - Properties
    static var homeAlreadyOpened = false
    
    private var ordersDataSource = [ProviderOrderCellViewModel]()
    private var providerExperiencesDataSource = [ProviderInfoCellViewModel]()
    private var providerStudiesDataSource = [ProviderInfoCellViewModel]()
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
    
    func fetchData() {
        status.value = .providerProfileLoaded(name: provider.user.firstName)
        providerModelToViewModel(provider)
        
        fetchProviderServices()
    }
    
    func fetchServices() {
        fetchProviderServices(updated: true)
    }
    
    func isEditedCell(indexPath: IndexPath) -> Bool {
        return (indexPath.section == Sections.list.rawValue || indexPath.section == Sections.secondList.rawValue) &&
            !(dataSource.value[indexPath.section][indexPath.row] is ProviderOrderCellViewModel)
    }
    
    func getViewModelAt(indexPath: IndexPath) -> CellViewModelProtocol? {
        return dataSource.value.safeContains(indexPath.section)?.safeContains(indexPath.row)
    }
    
    func updateInfo(models: [ProviderInfoServiceModel]?) {
        providerInfoToViewModels(models: models)
        setInfo()
    }
    
    func updateProvider(provider: ProviderProfile?) {
        guard let provider = provider else { return }
        
        let names = provider.user.firstName + " " + provider.user.lastName
        
        let profileViewModel = ProviderProfileCellViewModel(photoUrl: provider.photoUrl ?? "",
                                                            names: names,
                                                            description: provider.description)
        dataSource.value[Sections.header.rawValue] = [profileViewModel]
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
        
        switch index {
        case 0:
            setProviderServicesDataSource()
        case 1:
            setInfo()
        case 2:
            setOrdersDataSource()
        default:
            break
        }
    }
    
    func getAddServiceViewModel() -> AddProviderServiceViewModel {
        return AddProviderServiceViewModel(serviceModel: ProviderServiceModel.empty)
    }
    
    func getAddServiceViewModel(indexPath: IndexPath) -> AddProviderServiceViewModel? {
        guard let dates = dataSource.value[indexPath.section][indexPath.row] as? ProviderServiceCellViewModel else { return nil}
        let providerServiceModel = ProviderServiceModel(id: dates.productId,
                                                        photoUrl: dates.getImageUrl(),
                                                        name: dates.getName(),
                                                        price: dates.getPrice(),
                                                        description: dates.getDescription(),
                                                        serviceCategory: dates.getServiceCategory())
        return AddProviderServiceViewModel(serviceModel: providerServiceModel)
    }
    
    func getProviderServiceModelId(indexPath: IndexPath) -> Int? {
        guard let dates = dataSource.value[indexPath.section][indexPath.row] as? ProviderServiceCellViewModel else { return nil}
        return dates.productId
    }
    
    func getProviderInfoCellDataSource(indexPath: IndexPath) -> ProviderInfoCellDataSource? {
        guard let dates = dataSource.value[indexPath.section][indexPath.row] as? ProviderInfoCellDataSource else { return nil}
               return dates
    }
    
    func getProviderInfoViewModel(infoCell: ProviderInfoCellDataSource? = nil) -> ProviderInfoViewModel {
        guard let info = infoCell else {
            return ProviderInfoViewModel(info: ProviderInfoModel())
        }
        return ProviderInfoViewModel(info: ProviderInfoModel(id: info.id,
                                                             dataType: info.providerInfoType,
                                                             position: info.title,
                                                             location: info.subTitle,
                                                             startDate: info.startDate,
                                                             endDate: info.finishDate,
                                                             isCurrent: info.isCurrent,
                                                             country: info.country,
                                                             city: info.city))
    }
    
    // MARK: - Private Methods
    
    private func setOrdersDataSource() {
        dataSource.value[Sections.title.rawValue] = []
        dataSource.value[Sections.list.rawValue] = ordersDataSource
        dataSource.value[Sections.secondTitle.rawValue] = []
        dataSource.value[Sections.secondList.rawValue] = []
    }
    
    private func setInfo() {
        dataSource.value[Sections.title.rawValue] = [
            ProviderProfileTitleViewModel(title: "providerInfo.experinces".localized,
                                          showButton: true,
                                          providerInfoType: .experience)]
        dataSource.value[Sections.list.rawValue] = providerExperiencesDataSource
        dataSource.value[Sections.secondTitle.rawValue] = [
            ProviderProfileTitleViewModel(title: "providerInfo.studies".localized,
                                          showButton: true,
                                          providerInfoType: .study)]
        dataSource.value[Sections.secondList.rawValue] = providerStudiesDataSource
    }
    
    private func setProviderServicesDataSource() {
        dataSource.value[Sections.title.rawValue] = []
        dataSource.value[Sections.list.rawValue] = providerServicesDataSource
        dataSource.value[Sections.secondTitle.rawValue] = []
        dataSource.value[Sections.secondList.rawValue] = []
    }
    
    private func fetchProviderServices(updated: Bool = false) {
        if dataSource.value.indices.contains(Sections.list.rawValue) {
            dataSource.value[Sections.list.rawValue].removeAll()
        }
        
        isLoading.value = true
        
        service.fetchProviderServices { [weak self] (response: [ProviderService], error: CMError?) in
            
            guard error == nil else {
                self?.isLoading.value = false
                
                return
            }
            
            self?.servicesToViewModels(models: response)
            
            if !updated {
               self?.fetchProviderOrders()
            } else {
                self?.isLoading.value = false
            }
        }
    }
    
    func deleteService(providerId: Int) {
        isLoading.value = true
        
        service.deleteProviderService(serviceId: providerId) { [weak self] (_, error: CMError?) in
            self?.isLoading.value = false
            
            guard error == nil else {
                self?.status.value = .error(error: error.debugDescription)
                return
            }
            
            self?.fetchProviderServices(updated: true)
        }
    }
    
    func deleteInfo(id: Int) {
        
        isLoading.value = true
        service.deleteProviderInfo(providerId: id) { [weak self] (result, error) in
            self?.isLoading.value = false
            
            if let error = error {
                self?.status.value = .error(error: error.error)
                
                return
            }
            
            self?.updateInfo(models: result)
        }
    }
    
    private func fetchProviderOrders() {
        service.fetchProviderOrders { [weak self] (response: [Order], error: CMError?) in
            
            guard error == nil else {
                self?.isLoading.value = false
                
                return
            }
            
            self?.ordersToViewModels(models: response)
            self?.fetchProviderInfo()
        }
    }
    
    private func fetchProviderInfo() {
        service.fetchProviderInfo(id: provider.id) { [weak self] (response: [ProviderInfoServiceModel], error: CMError?) in
            self?.isLoading.value = false
            
            guard error == nil else {
                self?.isLoading.value = false
                
                return
            }
            
            self?.providerInfoToViewModels(models: response)
        }
    }
    
    private func providerModelToViewModel(_ provider: ProviderProfile) {
        let names = provider.user.firstName + " " + provider.user.lastName
        
        let profileViewModel = ProviderProfileCellViewModel(photoUrl: provider.photoUrl ?? "",
                                                            names: names,
                                                            description: provider.description)
        
        dataSource.value = [[profileViewModel]]
        dataSource.value.append([getButtonsCellViewModel()])
        dataSource.value.append([])
        dataSource.value.append([])
        dataSource.value.append([])
        dataSource.value.append([])
    }
    
    private func getButtonsCellViewModel(services: Int = 0, info: Int = 0, orders: Int = 0) -> SelectorCellViewModel {
        return SelectorCellViewModel(buttons: [
            SelectorCellButton(style: .green, title: "general.services".localized, items: services),
            SelectorCellButton(style: .greenBorder, title: "general.info".localized, items: info),
            SelectorCellButton(style: .greenBorder, title: "general.orders".localized, items: orders)
        ])
    }
    
    private func servicesToViewModels(models: [ProviderService]) {
        providerServicesDataSource = models.map {
            ProviderServiceCellViewModel(productImageUrl: $0.photoUrl ?? "",
                                         productName: $0.name,
                                         productDesc: $0.description,
                                         productPrice: $0.price,
                                         productCount: 0,
                                         productId: $0.getId(),
                                         serviceCategory: $0.getServiceCategory())
        }
        setProviderServicesDataSource()
    }
    
    private func ordersToViewModels(models: [Order]) {
        ordersDataSource = models.map {
            ProviderOrderCellViewModel(id: $0.id.asString,
                                       userName: $0.user.names,
                                       orderCategory: $0.serviceCategory?.name ?? "",
                                       orderState: $0.orderState.type,
                                       isLastItem: $0.id == models.last?.id)
        }
        let ordersCount = models.filter({ $0.orderState.type == .pending || $0.orderState.type == .paymentDone }).count
        dataSource.value[Sections.buttons.rawValue] = [getButtonsCellViewModel(orders: ordersCount)]
    }
    
    private func providerInfoToViewModels(models: [ProviderInfoServiceModel]?) {
        guard let models = models else { return }
        
        let studies = models.filter { $0.dataType == ProviderInfoType.study.rawValue }
        let experiences = models.filter { $0.dataType == ProviderInfoType.experience.rawValue }
        
        providerExperiencesDataSource = experiences.map {
            ProviderInfoCellViewModel(title: $0.position,
                                      subTitle: $0.location,
                                      startDate: $0.startDate,
                                      finishDate: $0.endDate,
                                      country: $0.country,
                                      city: $0.city,
                                      id: $0.id,
                                      isProvider: true,
                                      isCurrent: $0.isCurrent,
                                      providerInfoType: ProviderInfoType(rawValue: $0.dataType) ?? .experience)
        }
        
        providerStudiesDataSource = studies.map {
            ProviderInfoCellViewModel(title: $0.position,
                                      subTitle: $0.location,
                                      startDate: $0.startDate,
                                      finishDate: $0.endDate,
                                      country: $0.country,
                                      city: $0.city,
                                      id: $0.id,
                                      isProvider: true,
                                      isCurrent: $0.isCurrent,
                                      providerInfoType: ProviderInfoType(rawValue: $0.dataType) ?? .study)
        }
    }
}
