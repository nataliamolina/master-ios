//
//  MainViewController.swift
//  Master
//
//  Created by Luis Carlos Mejia Garcia on 12/26/19.
//  Copyright © 2019 Master. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {
    // MARK: - UI References
    @IBOutlet private weak var emailLoginButton: MButton!
    @IBOutlet private weak var registerButton: MButton!
    
    // MARK: - UI References
    @IBAction func emailLoginButtonAction() {
        navigationController?.pushViewController(EmailLoginViewController(), animated: true)
    }
    
    @IBAction func registerButtonAction() {
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        emailLoginButton.style = .onlyWhiteText
        registerButton.style = .onlyWhiteText
    }
}
