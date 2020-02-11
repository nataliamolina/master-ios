//
//  EmailLoginViewController.swift
//  Master
//
//  Created by Luis Carlos Mejia Garcia on 12/26/19.
//  Copyright © 2019 Master. All rights reserved.
//

import UIKit

class EmailLoginViewController: BaseViewController { 
    // MARK: - UI References
    @IBOutlet private weak var mainStackview: UIStackView!
    @IBOutlet private weak var emailTextField: MTextField!
    @IBOutlet private weak var passwordTextField: MTextField!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var loginButton: MButton!
    
    // MARK: - IBActions
    @IBAction private func loginButtonAction() {
        
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        addIconInNavigationBar()
        
        title = "Continuar con Email"
        
        loginButton.style = .green
        
        enableKeyboardDismiss()
        
        enableFieldSwitch(fieldsHolder: mainStackview, delegate: self)
    }
    
    private func routeToHome() {
        // TODO: Use routers!
        
        let navigationController = UINavigationController()
        navigationController.navigationBar.tintColor = .black
        navigationController.navigationBar.isTranslucent = false
        
        if #available(iOS 11.0, *) {
            navigationController.navigationBar.prefersLargeTitles = true
        }
        
        navigationController.setViewControllers([HomeViewController()], animated: false)
        
        let mainVC = navigationController
        mainVC.modalPresentationStyle = .fullScreen
        
        present(mainVC, animated: true, completion: nil)

    }
}

// MARK: - UITextFieldDelegate
extension EmailLoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleTextfieldSwitch(fieldsHolder: mainStackview, textField: textField) { [weak self] in
            self?.dismissKeyboard()
            self?.routeToHome()
        }
        
        return true
    }
}
