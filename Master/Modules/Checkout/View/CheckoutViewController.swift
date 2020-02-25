//
//  CheckoutViewController.swift
//  Master
//
//  Created by Carlos Mejía on 21/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class CheckoutViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    private let viewModel: CheckoutViewModel
    private let router: RouterBase<HomeRouterTransitions>
    
    // MARK: - Life Cycle
    init(router: RouterBase<HomeRouterTransitions>, viewModel: CheckoutViewModel) {
        self.router = router
        self.viewModel = viewModel
        
        super.init(nibName: String(describing: CheckoutViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        disableTitle()
        
        setupBindings()
        
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.registerNib(CheckoutFieldCell.self)
        tableView.registerNib(CheckoutHeaderCell.self)
        tableView.registerNib(CheckoutProviderCell.self)
        tableView.registerNib(ButtonCell.self)

        viewModel.createViewModels()
    }
    
    private func setupBindings() {
        viewModel.dataSource.bindTo(tableView, to: .dataSource)
    }
}

// MARK: - UITableViewDataSource
extension CheckoutViewController: CheckoutFieldCellDelegate {
    func cellTapped(_ cell: CheckoutFieldCell, viewModel: CheckoutFieldCellDataSource) {
        guard let index = tableView.indexPath(for: cell)?.row else {
            return
        }
        
        let viewModel = self.viewModel.getViewModelForCompleteAt(index: index)
        
        router.transition(to: .completeText(viewModel: viewModel, delegate: self))
    }
}

// MARK: - CompleteTextViewDelegate
extension CheckoutViewController: CompleteTextViewDelegate {
    func continueButtonTapped(viewModel: CompleteTextViewModel) {
        self.viewModel.updateViewModelValueAt(index: viewModel.index, value: viewModel.value ?? "")
    }
}

// MARK: - UITableViewDataSource
extension CheckoutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.getWith(cellViewModel: viewModel.getViewModelAt(indexPath: indexPath),
                                 indexPath: indexPath,
                                 delegate: self)
    }
}
