//
//  WelcomeViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 28/04/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class WelcomeViewModel {
    // MARK: - Properties
    private(set) var dataSource = [CellViewModelProtocol]()
    private let storageService: AppStorageProtocol
    
    // MARK: - Life Cycle
    init(storageService: AppStorageProtocol = AppStorage()) {
        self.storageService = storageService
        
        setupDataSource()
    }
    
    // MARK: - Private Methods
    private func setupDataSource() {
        dataSource.append(contentsOf: [
            BasicWelcomeCellViewModel(title: "welcome.screen1.title".localized,
                                      desc: "welcome.screen1.desc".localized,
                                      animName: .firstWelcome),
            
            BasicWelcomeCellViewModel(title: "welcome.screen2.title".localized,
                                      desc: "welcome.screen2.desc".localized,
                                      animName: .secondWelcome),
            
            BasicWelcomeCellViewModel(title: "welcome.screen3.title".localized,
                                      desc: "welcome.screen3.desc".localized,
                                      animName: .thirdWelcome)
        ])
    }
}
