//
//  ProviderMainViewController.swift
//  Master
//
//  Created by Carlos Mejía on 12/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class ProviderMainViewController: UIViewController {
    // MARK: - UI References
    @IBAction private func closeButtonAction(_ sender: Any) {
        navigationController?.hero.modalAnimationType =  .zoomOut
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Properties
    private let viewModel: ProviderMainViewModel
    private let router: RouterBase<ProviderRouterTransitions>
    
    // MARK: - Life Cycle
    init(router: RouterBase<ProviderRouterTransitions>, viewModel: ProviderMainViewModel) {
        self.router = router
        self.viewModel = viewModel
        
        super.init(nibName: String(describing: ProviderMainViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewModel.isOnBoardingRequired {
            router.transition(to: .onBoarding)
        } else {
            viewModel.getProviderProfile()
        }
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        // FIXME
        title = "Inicio"
        disableTitle()
        
        setupBindings()
    }
    
    private func setupBindings() {
        viewModel.isLoading.listen { isLoading in
            isLoading ? Loader.show() : Loader.dismiss()
        }
        
        viewModel.status.listen { [weak self] status in
            switch status {
            case .undefined:
                return
                
            case .error(let error):
                self?.showError(message: error)
                
            case .providerProfileLoaded:
                self?.router.transition(to: .home)
                
            case .needsToUploadPhoto:
                self?.router.transition(to: .uploadPhoto)
                
            case .needToCreateProviderAccount:
                self?.router.transition(to: .register)
            }
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension ProviderMainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return (otherGestureRecognizer is UIScreenEdgePanGestureRecognizer)
    }
}
