//
//  HomeViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 15/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import EasyBinding

enum HomeViewModelStatus {
    case undefined
    case error(error: String?)
}

class HomeViewModel {
    // MARK: - Properties
    let status = Var<HomeViewModelStatus>(.undefined)
    let isLoading = Var(false)
    let dataSource: Var<[[CellViewModelProtocol]]> = Var([[]])
    let hasPendingOrders = Var(false)
    let totalOrders = Var("0")
    
    private(set) var sectionTitles = [String]()
    private let service: HomeServiceProtocol
    private let ordersService: OrdersServiceProtocol
    
    // MARK: - Life Cycle
    init(service: HomeServiceProtocol? = nil, ordersService: OrdersServiceProtocol? = nil) {
        let defaultService = HomeService(connectionDependency: ConnectionManager())
        let defaultOrdersService = OrdersService(connectionDependency: ConnectionManager())
        
        self.ordersService = ordersService ?? defaultOrdersService
        self.service = service ?? defaultService
    }
    
    // MARK: - Public Methods
    
    func fetchServices() {
        isLoading.value = true
        
        service.fetchServices { [weak self] (response: [Service]?, error: CMError?) in
            self?.isLoading.value = false
            
            guard let models = response, error == nil else {
                self?.status.value = .error(error: error?.localizedDescription)
                
                return
            }
            
            self?.servicesToViewModels(models: models)
            self?.fetchOrders()
        }
    }
    
    // MARK: - Private Methods
    
    private func fetchOrders() {
        ordersService.fetchOrders { [weak self] (response: [Order]?, error: CMError?) in
            guard let models = response, error == nil else {
                return
            }
            
            self?.totalOrders.value = "\(models.count)"
            self?.hasPendingOrders.value = models.isEmpty
        }
    }
    
    private func servicesToViewModels(models: [Service]) {
        sectionTitles = models.map { $0.name }
        
        var data = [[CellViewModelProtocol]]()
        
        models.forEach {
            let viewModels: [CellViewModelProtocol] = $0.serviceCategories.map {
                CategoryCellViewModel(imageUrl: $0.imageUrl)
            }
            
            data.append(viewModels)
        }
        
        dataSource.value = data
    }
}
