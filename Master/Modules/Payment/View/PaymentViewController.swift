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
    @IBOutlet private weak var paymentView: UIView!
    @IBOutlet private weak var paymentezView: UIView!
    @IBOutlet private weak var paymentViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - UI Actions
    @IBAction func paymentButtonAction() {
        performCardValidation()
    }
    
    // MARK: - Properties
    private var paymentezAddVC: PaymentezAddNativeViewController?
    private let viewModel: PaymentViewModel
    private let router: RouterBase<OrdersRouterTransitions>
    
    // MARK: - Life Cycle
    init(viewModel: PaymentViewModel, router: RouterBase<OrdersRouterTransitions>) {
        self.viewModel = viewModel
        self.router = router
        
        super.init(nibName: String(describing: PaymentViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        setupBindings()
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
    
    private func setupBindings() {
        viewModel.isLoading.listen { isLoading in
            isLoading ? Loader.show() : Loader.dismiss()
        }
        
        viewModel.status.listen { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .paymentReady:
                    self?.router.transition(to: .paymentDone)
                    
                case .error(let error):
                    self?.showError(message: error)
                    
                default:
                    return
                }
            }
        }
    }
    
    private func performCardValidation() {
        guard let validCard = paymentezAddVC?.getValidCard() else {
            paymentezAddVC?.showWarning(message: Constants.invalidCard)
            
            return
        }
        
        dismissKeyboard()
        viewModel.addCardAndPay(validCard)
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
