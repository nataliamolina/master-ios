//
//  PaymentViewController.swift
//  Master
//
//  Created by Carlos Mejía on 1/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit
import Paymentez

private struct Constants {
    static let cardOwner = "payment.cardOwner".localized
    static let cardNumber = "payment.cardNumber".localized
    static let invalidCard = "payment.invalidCard".localized
}

class PaymentViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var paymentezView: UIView!
    @IBOutlet private weak var paymentViewBottomConstraint: NSLayoutConstraint!

    // MARK: - UI Actions
    @IBAction func paymentButtonAction() {
        performCardValidation()
    }
    
    // MARK: - Properties
    private var paymentezAddVC: PaymentezAddNativeViewController?
    
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
    
    // MARK: - Private Methods
    private func setupUI() {
        setupKeyboardListeners()
        disableTitle()
        enableKeyboardDismiss()
        
        paymentezAddVC = addPaymentezWidget(toView: paymentezView,
                                            delegate: nil,
                                            uid: Session.shared.profile.document,
                                            email: Session.shared.profile.email)
        
        paymentezAddVC?.showLogo = false
        paymentezAddVC?.baseColor = UIColor.Master.green
        paymentezAddVC?.nameTitle = Constants.cardOwner
        paymentezAddVC?.cardTitle = Constants.cardNumber
    }
    
    private func performCardValidation() {
        guard let validCard = paymentezAddVC?.getValidCard() else {
            paymentezAddVC?.showWarning(message: Constants.invalidCard)
            
            return
        }
        
        PaymentezSDKClient.add(validCard,
                               uid: Session.shared.profile.document,
                               email: Session.shared.profile.email) { (error: PaymentezSDKError?, card: PaymentezCard?) in
                                
                                
        }
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
        let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
        
        // TODO: Hacer lógica para iPhone pequeño y no tapar los campos con el teclado
        
        paymentViewBottomConstraint.constant = (keyboardHeight ?? 0)
        animateLayout()
    }
    
    @objc private func keyboardWillHide() {
        paymentViewBottomConstraint.constant = 0
        animateLayout()
    }
    
}
