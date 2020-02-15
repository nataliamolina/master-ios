//
//  MenuViewController.swift
//  Master
//
//  Created by Carlos Mejía on 15/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    // MARK: - UI Actions
    @IBAction private func logoutAction() {
        performLogout()
    }
    
    // MARK: - Properties
    private let router: RouterBase<HomeRouterTransitions>
    private let viewModel = MenuViewModel()
    
    // MARK: - Life Cycle
    init(router: RouterBase<HomeRouterTransitions>) {
        self.router = router
        
        super.init(nibName: String(describing: MenuViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Private Methods
    private func performLogout() {
        viewModel.logout()

        dismiss(animated: true, completion: nil)
        
        router.transition(to: .logout)
    }
}
