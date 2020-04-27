//
//  CitySelectorViewController.swift
//  Master
//
//  Created by Carlos Mejía on 24/04/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit
import Hero
import Lottie

class CitySelectorViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var animationView: UIView!
    
    // MARK: - Properties
    private var viewModel: CitySelectorViewModel
    private let router: RouterBase<MainRouterTransitions>

    // MARK: - Life Cycle
    init(viewModel: CitySelectorViewModel, router: RouterBase<MainRouterTransitions>) {
        self.viewModel = viewModel
        self.router = router
        
        super.init(nibName: String(describing: CitySelectorViewController.self), bundle: nil)
        
        hero.isEnabled = true
        hero.modalAnimationType = .selectBy(presenting: .zoom, dismissing: .zoomOut)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        
        viewModel.fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setupUI()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        let starAnimationView = AnimationView(name: AnimationType.city.rawValue)
        starAnimationView.frame = animationView.bounds
        starAnimationView.play()
        starAnimationView.loopMode = .loop
        
        animationView.addSubview(starAnimationView)
    }
    
    private func setupBindings() {
        viewModel.isLoading.bindTo(activityIndicator, to: .state)
        
        viewModel.status.listen { [weak self] status in
            switch status {
            case .dataLoaded:
                self?.updateCityList()
                
            case .citySelected:
                self?.router.transition(to: .home)
                
            case .error(let error):
                self?.showError(message: error)
                
            default:
                return
            }
        }
    }
    
    private func updateCityList() {
        viewModel.dataSource.forEach {
            let button = MButton(frame: .zero)
            button.title = $0.name
            button.style = .greenBorder
            button.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
            
            stackView.insertArrangedSubview(button, at: 0)
        }
    }
    
    @objc private func buttonSelected(_ button: MButton) {
        viewModel.citySelected(name: button.title ?? "")
    }
}
