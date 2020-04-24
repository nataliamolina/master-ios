//
//  SplashScreenViewController.swift
//  Master
//
//  Created by Luis Carlos Mejia Garcia on 12/26/19.
//  Copyright © 2019 Master. All rights reserved.
//

import UIKit
import EasyBinding
import Lottie

class SplashScreenViewController: UIViewController {
    // MARK: - UI Refereces
    @IBOutlet private weak var animationView: UIView!
    
    // MARK: - Properties
    private let router: RouterBase<MainRouterTransitions>
    private let viewModel: SplashScreenViewModel
    
    // MARK: - Life Cycle
    init(viewModel: SplashScreenViewModel, router: RouterBase<MainRouterTransitions>) {
        self.viewModel = viewModel
        self.router = router
        
        super.init(nibName: String(describing: SplashScreenViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        viewModel.status.listen { [weak self] status in
            guard let self = self else { return }
            
            switch status {
            case .preloadReady, .tokenExpired:
                self.router.transition(to: .home)
                
            case .needSelectCity:
                self.router.transition(to: .citySelector(viewModel: self.viewModel.getCitySelectorViewModel()))

            default:
                return
            }
        }
    }
}
