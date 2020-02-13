//
//  SplashScreenViewController.swift
//  Master
//
//  Created by Luis Carlos Mejia Garcia on 12/26/19.
//  Copyright © 2019 Master. All rights reserved.
//

import UIKit
import SimpleBinding
import NotificationBannerSwift

class SplashScreenViewController: BaseViewController {
    // MARK: - UI Refereces
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private let viewModel = SplashScreenViewModel()
    
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
        viewModel.isLoading.bindTo(activityIndicator)
        
        viewModel.status.valueDidChange = { [weak self] status in
            switch status {
            case .preloadReady(let hasSession):
                self?.route(toHome: hasSession)
            case .error(let error):
                self?.showError(message: error)
                
            default:
                return
            }
        }
    }
    
    private func showError(message: String?) {
        NotificationBanner(title: "Error", subtitle: message, style: .danger).show()
    }
    
    private func route(toHome: Bool) {
        // TODO: Use routers!
        
        let navigationController = UINavigationController()
        navigationController.navigationBar.tintColor = UIColor.Master.green
        
        if #available(iOS 11.0, *) {
            navigationController.navigationBar.prefersLargeTitles = true
        }
        
        navigationController.setViewControllers([MainViewController()], animated: false)
        
        let mainVC = navigationController
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.hero.isEnabled = true
        mainVC.hero.modalAnimationType = .zoom
        
        present(mainVC, animated: true, completion: nil)
    }
}
