//
//  ProviderRegisterViewController.swift
//  Master
//
//  Created by Carlos Mejía on 14/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class ProviderRegisterViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var documentTextField: MTextField!
    @IBOutlet private weak var bankNumberTextField: MTextField!
    @IBOutlet private weak var bankNameTextField: MTextField!
    @IBOutlet private weak var bankTypeTextField: MTextField!
    @IBOutlet private weak var bankTypeView: UIView!
    @IBOutlet private weak var aboutTextView: UITextView!

    // MARK: - Properties
    private var originalInset: UIEdgeInsets = .zero
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        dismissKeyboard()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        // FIXME
        title = "Registro"
        disableTitle()
        
        bankTypeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bankTypeFieldTapped)))
        
        originalInset = scrollView.contentInset
            
        enableKeyboardDismiss()
        disableTitle()
        setupKeyboardListeners()
        
        addIconInNavigationBar()
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
    
    @objc private func bankTypeFieldTapped() {
        router.transition(to: .listSelector(viewModel: viewModel.getListSelectorViewModel(), delegate: self))
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

// MARK: - ListSelectorViewControllerDelegate
extension ProviderRegisterViewController: ListSelectorViewControllerDelegate {
    func optionSelectedAt(index: Int, option: ListItemProtocol) {
        bankTypeTextField.text = option.value
    }
}
