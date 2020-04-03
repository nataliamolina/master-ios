//
//  ProviderRouter.swift
//  Master
//
//  Created by Carlos Mejía on 12/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

enum ProviderRouterTransitions {
    case main
    case register
    case uploadPhoto
    case home
    case legal
    case listSelector(viewModel: ListSelectorViewModel, delegate: ListSelectorViewControllerDelegate?)
    case addService(viewModel: AddProviderServiceViewModel, delegate: AddProviderServiceDelegate)
    case completeText(viewModel: CompleteTextViewModel, delegate: CompleteTextViewDelegate)
    case orderDetail(viewModel: ProviderOrderDetailViewModel)
}

class ProviderRouter: RouterBase<ProviderRouterTransitions> {
    // MARK: - Properties
    private let navigationController: MNavigationController
    private let providerNavigationController: MNavigationController

    // MARK: - Life Cycle
    init(navigationController: MNavigationController) {
        self.navigationController = navigationController
        self.providerNavigationController = MNavigationController()
        
        super.init()
        
    }
    
    // MARK: - Public Methods
    override func transition(to transition: ProviderRouterTransitions) {
        switch transition {
        case .main:
            handleMainTransition()
            
        case .home:
            handleHomeTransition()
            
        case .register:
            handleRegisterTransition()
            
        case .uploadPhoto:
            handleUploadTransition()
            
        case .listSelector(let viewModel, let delegate):
            handleListSelectorTransition(viewModel: viewModel, delegate: delegate)
            
        case .legal:
            handleLegalTransition()
            
        case .addService(let viewModel, let delegate):
            handleAddProviderService(viewModel: viewModel, delegate: delegate)
            
        case .completeText(let viewModel, let delegate):
            handleCompleteText(viewModel: viewModel, delegate: delegate)
            
        case .orderDetail(let viewModel):
            handleOrderDetail(viewModel: viewModel)
            
        }
    }
    
    // MARK: - Private Methods
    
    private func handleMainTransition() {
        let viewController = ProviderMainViewController(router: self, viewModel: ProviderMainViewModel())
        providerNavigationController.setViewControllers([viewController], animated: false)
        providerNavigationController.interactivePopGestureRecognizer?.delegate = viewController
        providerNavigationController.interactivePopGestureRecognizer?.isEnabled = true
        providerNavigationController.modalPresentationStyle = .fullScreen
        providerNavigationController.navigationBar.prefersLargeTitles = false
        
        navigationController.present(providerNavigationController, animated: true, completion: nil)
    }
    
    private func handleOrderDetail(viewModel: ProviderOrderDetailViewModel) {
        let viewController = ProviderOrderDetailViewController(viewModel: viewModel, router: self)
            
        providerNavigationController.pushViewController(viewController, animated: true)
    }
    
    private func handleCompleteText(viewModel: CompleteTextViewModel, delegate: CompleteTextViewDelegate) {
        let viewController = CompleteTextViewController(viewModel: viewModel, delegate: delegate)
            
        providerNavigationController.pushViewController(viewController, animated: true)
    }
    
    private func handleAddProviderService(viewModel: AddProviderServiceViewModel,
                                          delegate: AddProviderServiceDelegate) {
        
        let viewController = AddProviderServiceViewController(router: self,
                                                              viewModel: viewModel,
                                                              delegate: delegate)
        
        providerNavigationController.pushViewController(viewController, animated: true)
    }
    
    private func handleRegisterTransition() {
        let viewController = ProviderRegisterViewController(router: self, viewModel: ProviderRegisterViewModel())
        
        providerNavigationController.pushViewController(viewController, animated: true)
    }
    
    private func handleUploadTransition() {
        let viewController = ProviderPhotoViewController(viewModel: ProviderPhotoViewModel(), router: self)
        
        providerNavigationController.pushViewController(viewController, animated: true)
    }
    
    private func handleListSelectorTransition(viewModel: ListSelectorViewModel, delegate: ListSelectorViewControllerDelegate?) {
        let viewController = ListSelectorViewController(viewModel: viewModel, delegate: delegate)
        
        providerNavigationController.pushViewController(viewController, animated: true)
    }
    
    private func handleHomeTransition() {
        guard let providerProfile = Session.shared.provider else {
            return
        }
        
        let viewController = ProviderHomeViewController(viewModel: ProviderHomeViewModel(provider: providerProfile), router: self)

        providerNavigationController.popToRootViewController { [weak self] in
            self?.providerNavigationController.pushViewController(viewController, animated: true)
        }
    }
    
    private func handleLegalTransition() {
        let viewController = LegalViewController()
        
        providerNavigationController.pushViewController(viewController, animated: true)
    }
}
