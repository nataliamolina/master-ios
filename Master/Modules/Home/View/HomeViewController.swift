//
//  HomeViewController.swift
//  Master
//
//  Created by Luis Carlos Mejia Garcia on 12/26/19.
//  Copyright © 2019 Master. All rights reserved.
//

import UIKit
import SideMenu
import Hero

class HomeViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var pendingView: UIView!
    @IBOutlet private weak var pendingLabel: UILabel!
    
    // MARK: - Properties
    private let viewModel = HomeViewModel()
    private let router: HomeRouter
    private let heroTransition = HeroTransition()

    // MARK: - Life Cycle
    
    init(router: HomeRouter) {
        self.router = router
        
        super.init(nibName: String(describing: HomeViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupNavigationGesture()
        
        if HomeViewModel.needsToOpenOrders {
            HomeViewModel.needsToOpenOrders = false
            
            router.transition(to: .orders)
        }
    }
    
    private func setupUI() {
        disableTitle()
        
        setupBindings()
        
        pendingView.isHidden = true
        pendingView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                action: #selector(pendingViewTapped)))
        
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.registerNib(CategoryCell.self)
        
        setupMenuIcon()
        setupLogoIcon()
        
        viewModel.fetchServices()
    }
    
    private func setupBindings() {
        viewModel.hasPendingOrders.listen { hasPendingOrders in
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.pendingView.isHidden = !hasPendingOrders
            }
        }
        
        viewModel.dataSource.bindTo(tableView, to: .dataSource)
        viewModel.totalOrders.bindTo(pendingLabel, to: .text)
        
        viewModel.isLoading.listen { isLoading in
            isLoading ? Loader.show() : Loader.dismiss()
        }
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
        showMenu(router: router)
    }
    
    @objc private func pendingViewTapped() {
        router.transition(to: .orders)
    }
}

// MARK: - CategoryCellDelegate
extension HomeViewController: CategoryCellDelegate {
    func cellTapped(_ cell: CategoryCell) {
        guard
            let indexPath = tableView.indexPath(for: cell),
            let cellViewModel = viewModel.getViewModelAt(indexPath: indexPath) as? CategoryCellViewModel else {
                return
        }
        
        router.transition(to: .categoryDetail(id: cellViewModel.serviceId,
                                              serviceImageUrl: cellViewModel.imageUrl))
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
        return tableView.getWith(cellViewModel: viewModel.getViewModelAt(indexPath: indexPath),
                                 indexPath: indexPath,
                                 delegate: self)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension HomeViewController: UIGestureRecognizerDelegate {
    private func setupNavigationGesture() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return (otherGestureRecognizer is UIScreenEdgePanGestureRecognizer)
    }
}
