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
import Lottie

class SplashScreenViewController: UIViewController {
    // MARK: - UI Refereces
    @IBOutlet private weak var animationView: UIView!
    
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
        let starAnimationView = AnimationView(name: AnimationType.loader.rawValue)
        starAnimationView.frame = animationView.bounds
        starAnimationView.play()
        starAnimationView.loopMode = .loop
        
        animationView.addSubview(starAnimationView)
        
        setupBindings()
    }
    
    private func setupBindings() {
        viewModel.status.observe = { [weak self] status in
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
