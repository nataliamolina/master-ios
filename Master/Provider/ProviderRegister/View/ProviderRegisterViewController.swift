//
//  ProviderRegisterViewController.swift
//  Master
//
//  Created by Carlos Mejía on 14/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class ProviderRegisterViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: ProviderRegisterViewModel
    private let router: RouterBase<ProviderRouterTransitions>
    
    // MARK: - Life Cycle
    init(router: RouterBase<ProviderRouterTransitions>, viewModel: ProviderRegisterViewModel) {
        self.router = router
        self.viewModel = viewModel
        
        super.init(nibName: String(describing: ProviderRegisterViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        disableTitle()
    }
}
