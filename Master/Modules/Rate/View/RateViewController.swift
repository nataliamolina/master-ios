//
//  RateViewController.swift
//  Master
//
//  Created by Carlos Mejía on 9/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit
import FloatRatingView

class RateViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var rateView: FloatRatingView!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var mainContainerTopView: NSLayoutConstraint!
    
    // MARK: - UI Actions
    @IBAction private func rateButtonAction() {
        dismissKeyboard()
        viewModel.postRate(comment: textView.text, rate: rateView.rating)
    }
    
    // MARK: - Properties
    private let viewModel: RateViewModel
    private let router: RouterBase<OrdersRouterTransitions>
    
    // MARK: - Life Cycle
    init(router: RouterBase<OrdersRouterTransitions>, viewModel: RateViewModel) {
        self.router = router
        self.viewModel = viewModel
        
        super.init(nibName: String(describing: RateViewController.self), bundle: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    // MARK: - Private Methods
    private func setupUI() {
        enableKeyboardDismiss()
        setupBindings()
        setupKeyboardListeners()
        
        rateView.minRating = 1
        rateView.maxRating = 5
        rateView.fullImage = .fullStar
        rateView.emptyImage = .emptyStar
        rateView.rating = 4
        rateView.type = .halfRatings
    }
    
    private func setupBindings() {
        viewModel.isLoading.listen { isLoading in
            isLoading ? Loader.show() : Loader.dismiss()
        }
        
        viewModel.status.listen { [weak self] status in
            switch status {
            case .error:
                self?.showError(message: String.Lang.generalError)

            case .rateSucceded:
                self?.router.transition(to: .endFlow(onComplete: {
                    self?.showSuccess(message: "¡Gracias por calificar el servicio!")
                }))
                
            default:
                return
            }
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
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        let percentage: CGFloat = screenHeight < 600 ? 40 : 20
        
        mainContainerTopView.constant = -(screenHeight * percentage / 100)
        animateLayout()
    }
    
    @objc private func keyboardWillHide() {
        mainContainerTopView.constant = 0
        animateLayout()
    }
}
