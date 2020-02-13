//
//  MainViewController.swift
//  Master
//
//  Created by Luis Carlos Mejia Garcia on 12/26/19.
//  Copyright © 2019 Master. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var emailLoginButton: MButton!
    @IBOutlet private weak var registerButton: MButton!
    
    // MARK: - UI References
    @IBAction func emailLoginButtonAction() {
        router?.transition(to: .emailLogin)
    }
    
    @IBAction func registerButtonAction() {
        router?.transition(to: .register)
    }
    
    // MARK: - Properties
    var router: RouterBase<MainRouterTransitions>?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        title = ""
        
        emailLoginButton.style = .onlyWhiteText
        registerButton.style = .onlyWhiteText
    }
}
