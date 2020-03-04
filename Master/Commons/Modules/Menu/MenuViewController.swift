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
    @IBOutlet private weak var userNamesLabel: UILabel!
    @IBOutlet private weak var userImageView: UIImageView!
    
    // MARK: - UI Actions
    @IBAction private func logoutAction() {
        performLogout()
    }
    
    @IBAction func ordersButtonAction() {
        router.transition(to: .ordersList)
    }
    
    @IBAction func legalButtonAction() {
        router.transition(to: .legal)
    }
    
    // MARK: - Properties
    private let router: RouterBase<MenuRouterTransitions>
    private let viewModel = MenuViewModel()
    
    // MARK: - Life Cycle
    init(router: RouterBase<MenuRouterTransitions>) {
        self.router = router
        
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
    
    // MARK: - Private Methods
    private func setupUI(firstName: String, imageUrl: String) {
        userNamesLabel.text = firstName
        userImageView.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage.avatar)
    }
    
    private func performLogout() {
        viewModel.logout()

        dismiss(animated: true, completion: nil)
        
        router.transition(to: .logout)
    }
}
