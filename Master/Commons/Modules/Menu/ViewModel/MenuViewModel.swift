//
//  MenuViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 15/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import GoogleSignIn

class MenuViewModel {
    // MARK: - Properties
    private var currentCity: String {
        let result: String? = storageService.get(key: CitySelectorViewModel.Keys.cityName.rawValue)
        
        return result ?? ""
    }
    
    private let service: MenuServiceProtocol
    private let storageService: AppStorageProtocol
    
    private(set) var dataSource = [CellViewModelProtocol]()

    // MARK: - Life Cycle
    init(service: MenuServiceProtocol? = nil,
         storageService: AppStorageProtocol? = nil) {
        
        let defaultService = MenuService(connectionDependency: ConnectionManager())
        let defaultStorageService = AppStorage()

        self.service = service ?? defaultService
        self.storageService = storageService ?? defaultStorageService
        
        createMenu()
    }
    
    func logout() {
        Session.shared.logout()
    }
    
    func getViewModelAt(indexPath: IndexPath) -> CellViewModelProtocol? {
        return dataSource.safeContains(indexPath.row)
    }
    
    // MARK: - Private Methods
    private func createMenu() {
        let serviceTitle = MenuTitleCellViewModel(title: .services, isFirstItem: true)
        let accountTitle = MenuTitleCellViewModel(title: .account, isFirstItem: false)
        let cityTitle = MenuTitleCellViewModel(title: .city, isFirstItem: false)
        
        let orders = MenuOptionCellViewModel(option: .orders)
        let legal = MenuOptionCellViewModel(option: .legal)
        let help = MenuOptionCellViewModel(option: .help)
        let city = MenuOptionCellViewModel(option: .city(name: currentCity))
        
        dataSource.append(serviceTitle)
        dataSource.append(orders)
        dataSource.append(accountTitle)
        dataSource.append(legal)
        dataSource.append(help)
        dataSource.append(cityTitle)
        dataSource.append(city)
    }
}
