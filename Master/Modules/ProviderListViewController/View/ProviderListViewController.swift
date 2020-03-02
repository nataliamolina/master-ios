//
//  ServiceDetailViewController.swift
//  Master
//
//  Created by Carlos Mejía on 15/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit
import Lottie

class ProviderListViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var lottieView: UIView!
    @IBOutlet private weak var emptyStateView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerImage: UIImageView!
    
    // MARK: - Properties
    private let viewModel: ProviderListViewModel
    private let router: RouterBase<HomeRouterTransitions>
    
    // MARK: - Life Cycle
    init(viewModel: ProviderListViewModel, router: RouterBase<HomeRouterTransitions>) {
        self.viewModel = viewModel
        self.router = router
        
        super.init(nibName: String(describing: ProviderListViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        disableTitle()
        
        headerImage.kf.setImage(with: URL(string: viewModel.serviceImageUrl ?? ""))
        
        emptyStateView.isHidden = true
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.registerNib(ProviderCell.self)
        
        setupBindings()
        
        viewModel.fetchDetail()
    }
    
    private func setupBindings() {
        viewModel.status.listen { [weak self] status in
            switch status {
            case .emptyStateRequired:
                self?.setupEmptyState()
                
            default:
                return
            }
        }
        
        viewModel.dataSource.bindTo(tableView, to: .dataSource)
        
        viewModel.isLoading.listen { isLoading in
            isLoading ? Loader.show() : Loader.dismiss()
        }
    }
    
    private func setupEmptyState() {
        emptyStateView.isHidden = false
        
        let starAnimationView = AnimationView(name: AnimationType.emptyStateForProviders.rawValue)
        starAnimationView.frame = lottieView.bounds
        starAnimationView.play()
        starAnimationView.loopMode = .loop
        
        lottieView.addSubview(starAnimationView)
    }
}

// getProviderProfileViewModelAt

// MARK: - ProviderCellDelegate
extension ProviderListViewController: ProviderCellDelegate {
    func cellTappped(_ cell: ProviderCell) {
        guard
            let indexPath = tableView.indexPath(for: cell),
            let providerViewModel = viewModel.getProviderProfileViewModelAt(indexPath: indexPath) else {
                
                return
        }
        
        router.transition(to: .providerDetail(viewModel: providerViewModel))
    }
}

// MARK: - UITableViewDataSource
extension ProviderListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.getWith(cellViewModel: viewModel.getViewModelAt(indexPath: indexPath),
                                 indexPath: indexPath,
                                 delegate: self)
    }
}
