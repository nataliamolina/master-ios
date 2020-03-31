//
//  AddProviderServiceViewController.swift
//  Master
//
//  Created by Carlos Mejía on 30/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class AddProviderServiceViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var serviceImageTakenView: UIImageView!
    @IBOutlet private weak var serviceNameLabel: UITextField!
    @IBOutlet private weak var serviceDescLabel: UITextView!
    @IBOutlet private weak var servicePriceLabel: UITextField!
    @IBOutlet private weak var serviceCategoryLabel: UITextField!
    @IBOutlet private weak var serviceCategoryView: UIView!
    @IBOutlet private weak var serviceImageView: UIView!

    // MARK: - UI Actions
    @IBAction private func continueButtonAction() {
        
    }
    
    @IBAction private func legalButtonAction() {
        
    }
    
    // MARK: - Properties
    private var originalInset: UIEdgeInsets = .zero
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        dismissKeyboard()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
        
    // MARK: - Public Methods
    
    // MARK: - Private Methods
    private func setupUI() {
        originalInset = scrollView.contentInset
        
        setupKeyboardListeners()
        disableTitle()
        addIconInNavigationBar()
        enableKeyboardDismiss()
    }
    
    private func setupBindings() {
        
    }
    
    private func setupKeyboardListeners() {
           NotificationCenter.default.addObserver(self,
                                                  selector: #selector(keyboardWillShow(notification:)),
                                                  name: UIResponder.keyboardWillShowNotification ,
                                                  object: nil)
           
           NotificationCenter.default.addObserver(self,
                                                  selector: #selector(keyboardWillHide),
                                                  name: UIResponder.keyboardWillHideNotification ,
                                                  object: nil)
       }
       
       @objc private func keyboardWillShow(notification: NSNotification) {
           let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
           
           scrollView.contentInset = UIEdgeInsets(top: originalInset.top,
                                                  left: originalInset.left,
                                                  bottom: originalInset.bottom + (keyboardSize?.height ?? 0),
                                                  right: originalInset.right)
       }
       
       @objc private func keyboardWillHide() {
           scrollView.contentInset = originalInset
           animateLayout()
       }
}
