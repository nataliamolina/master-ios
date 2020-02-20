//
//  SplashScreenViewController.swift
//  Master
//
//  Created by Luis Carlos Mejia Garcia on 12/26/19.
//  Copyright © 2019 Master. All rights reserved.
//

import UIKit
import EasyBinding
import NotificationBannerSwift

class SplashScreenViewController: UIViewController {
    // MARK: - UI Refereces
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private var router: RouterBase<MainRouterTransitions> {
        return MainRouter(rootViewController: self)
    }
    
    private let viewModel = SplashScreenViewModel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchRequiredServices()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        viewModel.isLoading.bindTo(activityIndicator, to: .state)
        
        viewModel.status.valueDidChange = { [weak self] status in
            switch status {
            case .preloadReady(let hasSession):
                self?.route(toHome: hasSession)
                
            case .error(let error):
                self?.showError(message: error)
                
            case .tokenExpired:
                self?.route(toHome: false)
                
            default:
                return
            }
        }
    }
    
    private func route(toHome: Bool) {
        if toHome {
            router.transition(to: .home)
        } else {
            router.transition(to: .main)
        }
    }
}
