//
//  ProviderWelcomeViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 3/05/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

class ProviderWelcomeViewModel {
    // MARK: - Properties
    private(set) var dataSource = [CellViewModelProtocol]()
    private let storageService: AppStorageProtocol
    
    // MARK: - Life Cycle
    init(storageService: AppStorageProtocol = AppStorage()) {
        self.storageService = storageService
        
        setupDataSource()
    }
    
    // MARK: - Public Methods
    func getCitySelectorViewModel() -> CitySelectorViewModel {
        return CitySelectorViewModel()
    }
    
    // MARK: - Private Methods
    private func setupDataSource() {
        dataSource.append(contentsOf: [
            BasicWelcomeCellViewModel(title: "",
                                      desc: "welcome.provider.screen1.desc".localized,
                                      animName: .providerFirstWelcome),
            
            BasicWelcomeCellViewModel(title: "",
                                      desc: "welcome.provider.screen2.desc".localized,
                                      animName: .providerSecondWelcome)
        ])
    }
}
