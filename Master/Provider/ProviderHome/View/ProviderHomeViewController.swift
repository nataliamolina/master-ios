//
//  ProviderHomeViewController.swift
//  Master
//
//  Created by Carlos Mejía on 12/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class ProviderHomeViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - UI Actions
    @IBAction private func addServiceButtonAction() {
        router.transition(to: .addService(viewModel: viewModel.getAddServiceViewModel(),
                                          delegate: self))
    }
    
    // MARK: - Properties
    private let router: RouterBase<ProviderRouterTransitions>
    private let viewModel: ProviderHomeViewModel
    
    // MARK: - Life Cycle
    
    init(viewModel: ProviderHomeViewModel, router: RouterBase<ProviderRouterTransitions>) {
        self.viewModel = viewModel
        self.router = router
        
        super.init(nibName: String(describing: ProviderHomeViewController.self), bundle: nil)
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
        
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.registerNib(ProviderServiceCell.self)
        tableView.registerNib(ProviderProfileCell.self)
        tableView.registerNib(SelectorCell.self)
        tableView.registerNib(ProviderOrderCell.self)
        
        setupBindings()
        
        viewModel.fetchData()
        
        checkPendingDetailFromPush()
        
        ProviderHomeViewModel.homeAlreadyOpened = true
    }
    
    private func checkPendingDetailFromPush() {
        if let currentRouter = (router as? ProviderRouter),
            let pendingViewModel = currentRouter.pendingDetailFromPush {
            
            router.transition(to: .orderDetail(viewModel: pendingViewModel))
            currentRouter.pendingDetailFromPush = nil
        }
    }
    
    private func setupBindings() {
        viewModel.dataSource.bindTo(tableView, to: .dataSource)
        
        viewModel.isLoading.listen { isLoading in
            isLoading ? Loader.show() : Loader.dismiss()
        }
        
        viewModel.status.listen { [weak self] status in
            switch status {
            case .error(let error):
                self?.showError(message: error)
                
            case .providerProfileLoaded(let name):
                self?.title = name
                
            case .undefined:
                return
            }
        }
    }
}

// MARK: - SelectorCellDelegate
extension ProviderHomeViewController: SelectorCellDelegate {
    func buttonTapped(at index: Int, title: String, button: MButton) {
        viewModel.toggleCommentsSection(with: index)
    }
}

// MARK: - ProviderInfoCellDelegate
extension ProviderHomeViewController: ProviderInfoCellDelegate {
    func editCellTapped(_ cell: ProviderInfoCell, viewModel: ProviderInfoCellDataSource) {
        router.transition(to: .orderDetail(viewModel: ProviderOrderDetailViewModel(orderId: viewModel.id.asInt)))
    }
}

// MARK: - UITableViewDataSource
extension ProviderHomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dataSource.value.count
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

// MARK: - AddProviderServiceDelegate
extension ProviderHomeViewController: AddProviderServiceDelegate {
    func serviceAdded() {
        viewModel.fetchData()
    }
}

// MARK: - AddProviderServiceDelegate
extension ProviderHomeViewController: ProviderOrderCellDelegate {
    func cellTapped(_ cell: ProviderOrderCell, viewModel: ProviderOrderCellDataSource) {
        router.transition(to: .orderDetail(viewModel: ProviderOrderDetailViewModel(orderId: viewModel.id.asInt)))
    }
}
