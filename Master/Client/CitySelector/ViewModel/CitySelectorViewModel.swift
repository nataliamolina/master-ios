//
//  CitySelectorViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 24/04/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import EasyBinding

enum CitySelectorViewModelStatus {
    case dataLoaded
    case citySelected
    case undefined
    case error(error: String?)
}

class CitySelectorViewModel {
    // MARK: - Properties
    enum Keys: String {
        case cityId
        case cityName
    }
    
    private(set) var dataSource = [CitySelectorItem]()
    private let storedData: AppStorageProtocol

    let isLoading = Var<Bool>(false)
    let status = Var<CitySelectorViewModelStatus>(.undefined)
    let service: CitySelectorServiceProtocol
    
    // MARK: - Life Cycle
    init(service: CitySelectorServiceProtocol? = nil, storedData: AppStorageProtocol? = nil) {
        let connectionManager = ConnectionManager()
        
        let defaultStorageService = AppStorage()
        let defaultService = CitySelectorService(connectionDependency: connectionManager)
        
        self.service = service ?? defaultService
        self.storedData = storedData ?? defaultStorageService
    }
    
    func fetchData() {
        isLoading.value = true
        
        service.fetchCities { [weak self] (response: [City], error: CMError?) in
            self?.isLoading.value = false
            
            if error != nil {
                self?.status.value = .error(error: error?.localizedDescription)

                return
            }
            
            self?.modelsToDataSource(models: response)
            self?.status.value = .dataLoaded
        }
    }
    
    func citySelected(name: String) {
        guard let selectedCity = dataSource.filter({ $0.name == name }).first else {
            return
        }
        
        storedData.save(value: selectedCity.name, key: Keys.cityName.rawValue)
        storedData.save(value: selectedCity.id, key: Keys.cityId.rawValue)
        
        status.value = .citySelected
    }
    
    // MARK: - Private Methods
    private func modelsToDataSource(models: [City]) {
        dataSource = models.map {
            CitySelectorItem(id: $0.id, name: $0.name)
        }
    }
}
