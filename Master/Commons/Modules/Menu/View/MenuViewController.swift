//
//  MenuViewController.swift
//  Master
//
//  Created by Carlos Mejía on 15/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var topConstraint: NSLayoutConstraint!
    @IBOutlet private weak var dismissAreaView: UIView!
    @IBOutlet private weak var mainContainerViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var mainContainerView: UIView!
    @IBOutlet private weak var userNamesLabel: UILabel!
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var logoutButton: MButton!
    @IBOutlet private weak var welcomeLabel: UILabel!
    
    // MARK: - UI Actions
    @IBAction private func logoutAction() {
        performLogout()
    }
    
    @IBAction func ordersButtonAction() {
        closeMenu { [weak self] in
            self?.router.transition(to: .ordersList)
        }
    }
    
    @IBAction func legalButtonAction() {
        closeMenu { [weak self] in
            self?.router.transition(to: .legal)
        }
    }
    
    @IBAction func helpButtonAction() {
        closeMenu { [weak self] in
            self?.router.transition(to: .help)
        }
    }
    
    @IBAction func providerModButtonAction() {
        closeMenu { [weak self] in
            self?.router.transition(to: .provider)
        }
    }
    
    // MARK: - Properties
    private let animationTime: TimeInterval = 0.2
    private let menuBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    private let router: RouterBase<MenuRouterTransitions>
    private let viewModel: MenuViewModel
    
    // MARK: - Life Cycle
    init(viewModel: MenuViewModel, router: RouterBase<MenuRouterTransitions>) {
        self.router = router
        self.viewModel = viewModel
        
        super.init(nibName: String(describing: MenuViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI(firstName: Session.shared.profile.firstName,
                imageUrl: Session.shared.profile.imageUrl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showMenu()
    }
    
    // MARK: - Private Methods
    private func setupUI(firstName: String, imageUrl: String) {
        if !Session.shared.isLoggedIn {
            logoutButton.setTitle("menu.login".localized, for: .normal)
            welcomeLabel.text = "menu.greetings.nosession".localized
        } else {
            logoutButton.setTitle("menu.logout".localized, for: .normal)
        }
        
        let topOffset: CGFloat = 20
        topConstraint.constant = UIApplication.shared.statusBarFrame.height + topOffset
        
        userNamesLabel.text = firstName
        userImageView.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage.avatar)
        
        hideMenu()
        setupGestureRecognizers()
    }
    
    private func performLogout() {
        if !Session.shared.isLoggedIn {
            closeMenu { [weak self] in
                self?.router.transition(to: .login)
            }
            
            return
        }
        
        viewModel.logout()
        
        dismiss(animated: true, completion: nil)
        
        router.transition(to: .logout)
    }
    
    private func setupGestureRecognizers() {
        mainContainerView.addGestureRecognizer(UIPanGestureRecognizer(target: self,
                                                                      action: #selector(menuSwapped(_:))))
        
        addDismissGesture()
    }
    
    private func addDismissGesture() {
        dismissAreaView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                    action: #selector(dismissView)))
    }
    
    private func hideMenu() {
        mainContainerViewTrailingConstraint.constant = -UIScreen.main.bounds.width
    }
    
    private func showMenu() {
        view.bringSubviewToFront(mainContainerView)
        mainContainerViewTrailingConstraint.constant = .zero
        
        UIView.animate(withDuration: animationTime) { [weak self] in
            self?.view.layoutIfNeeded()
            self?.view.backgroundColor = self?.menuBackgroundColor
        }
    }
    
    @objc private func dismissView() {
        closeMenu()
    }
    
    @objc private func closeMenu(completion: (() -> Void)? = nil) {
        hideMenu()
        
        UIView.animate(withDuration: animationTime, animations: { [weak self] in
            self?.view.layoutIfNeeded()
            self?.view.backgroundColor = .clear
            }, completion: { [weak self] _ in
                self?.dismiss(animated: false, completion: completion)
        })
    }
    
    @objc private func menuSwapped(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: mainContainerView)
        
        if panGesture.state == .changed {
            mainContainerViewTrailingConstraint.constant = translation.x >= 0 ? .zero : translation.x
            view.layoutIfNeeded()
            
            return
        }
        
        if panGesture.state == .ended {
            let revertArea: CGFloat = -(mainContainerView.bounds.width / 2)
            
            if translation.x > revertArea {
                mainContainerViewTrailingConstraint.constant = .zero
                
                UIView.animate(withDuration: animationTime) { [weak self] in
                    self?.view.layoutIfNeeded()
                }
                
                return
            }
            
            closeMenu()
        }
    }
}
