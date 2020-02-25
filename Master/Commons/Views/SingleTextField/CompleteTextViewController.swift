//
//  SingleTextFieldViewController.swift
//  Master
//
//  Created by Carlos Mejía on 24/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

protocol CompleteTextViewDelegate: class {
    func continueButtonTapped(viewModel: CompleteTextViewModel)
}

class CompleteTextViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var helpLabel: UILabel!
    @IBOutlet private weak var backButton: MButton!
    @IBOutlet private weak var backButtonBottomConstraint: NSLayoutConstraint!
    
    // MARK: - UI Actions
    @IBAction private func backButtonAction() {
        if let navController = navigationController {
            navController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
        
        delegate?.continueButtonTapped(viewModel: viewModel)
    }
    
    // MARK: - Life Cycle
    private weak var delegate: CompleteTextViewDelegate?
    private let backButtonBottomValue: CGFloat = 10
    private let viewModel: CompleteTextViewModel
    
    // MARK: - Life Cycle
    init(viewModel: CompleteTextViewModel, delegate: CompleteTextViewDelegate?) {
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init(nibName: String(describing: CompleteTextViewController.self), bundle: nil)
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
        setupKeyboardListeners()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        textField.resignFirstResponder()
    }
    
    // MARK: - Private Methods
    
    // MARK: - Private Methods
    private func setupUI() {
        titleLabel.text = viewModel.title
        textField.text = viewModel.value
        textField.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
        textField.keyboardType = viewModel.keyboardType
        
        if !viewModel.placeholder.isEmpty {
            textField.placeholder = viewModel.placeholder
        }
        
        if !viewModel.desc.isEmpty {
            helpLabel.text = viewModel.desc
        }

        viewModel.isValidForm.bindTo(backButton, to: .state)
        
        enableKeyboardDismiss()
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
        
        backButtonBottomConstraint.constant = (keyboardHeight ?? 0) + backButtonBottomValue
        performLayoutAnimations()
    }
    
    @objc private func keyboardWillHide() {
        backButtonBottomConstraint.constant = backButtonBottomValue
        performLayoutAnimations()
    }
    
    @objc private func valueChanged() {
        viewModel.value = textField.text
    }
    
    private func performLayoutAnimations() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}
