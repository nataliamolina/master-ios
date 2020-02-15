//
//  HomeViewController.swift
//  Master
//
//  Created by Luis Carlos Mejia Garcia on 12/26/19.
//  Copyright © 2019 Master. All rights reserved.
//

import UIKit
import SideMenu

class HomeViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var pendingView: UIView!
    @IBOutlet private weak var pendingLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private let viewModel = HomeViewModel()
    var router: RouterBase<HomeRouterTransitions>?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupNavigationGesture()
    }
    
    private func setupUI() {
        title = ""
        
        setupBindings()
        
        pendingView.isHidden = true
        
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.registerNib(CategoryCell.self)
        
        setupMenuIcon()
        setupLogoIcon()
        
        viewModel.fetchServices()
    }
    
    private func setupBindings() {
        viewModel.hasPendingOrders.valueDidChange = { hasPendingOrders in
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.pendingView.isHidden = !hasPendingOrders
            }
        }
        
        viewModel.dataSource.bindTo(tableView, to: .dataSource)
        viewModel.totalOrders.bindTo(pendingLabel, to: .text)
        viewModel.isLoading.bindTo(activityIndicator, to: .state)
    }
    
    // MARK: - Private Methods
    private func setupMenuIcon() {
        let leftImage = UIBarButtonItem(image: .menu, style: .plain, target: self, action: #selector(menuButtonTapped))
        leftImage.tintColor = .black
        navigationItem.leftBarButtonItem = leftImage
    }
    
    private func setupLogoIcon() {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .greenLogoIcon
        
        navigationItem.titleView = imageView
    }
    
    @objc private func menuButtonTapped() {
        showMenu()
    }
}

// MARK: - CategoryCellDelegate
extension HomeViewController: CategoryCellDelegate {
    func cellTapped(_ cell: CategoryCell) {
        router?.transition(to: .categoryDetail)
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dataSource.value.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sectionTitles.safeContains(section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.value.safeContains(section)?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.dataSource.value.safeContains(indexPath.section)?.safeContains(indexPath.row)
        let identifier = cellViewModel?.identifier ?? ""
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        (cell as? ConfigurableCellProtocol)?.setupWith(viewModel: cellViewModel,
                                                       indexPath: indexPath,
                                                       delegate: self)
        
        return cell
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension HomeViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return (otherGestureRecognizer is UIScreenEdgePanGestureRecognizer)
    }
}
