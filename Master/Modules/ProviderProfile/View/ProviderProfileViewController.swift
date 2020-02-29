//
//  ProviderProfileViewController.swift
//  Master
//
//  Created by Carlos Mejía on 16/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class ProviderProfileViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var totalViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var totalViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var totalLabel: UILabel!
    
    // MARK: - UI Actions
    @IBAction private func continueButtonAction() {
        guard let checkoutViewModel = viewModel.getViewModelForCheckout() else { return }
        router.transition(to: .checkout(viewModel: checkoutViewModel))
    }
    
    // MARK: - Properties
    private let router: RouterBase<HomeRouterTransitions>
    private let viewModel: ProviderProfileViewModel
    private var isTotalViewVisible: Bool {
        return totalViewBottomConstraint.constant == 0
    }
    
    // MARK: - Life Cycle
    
    init(viewModel: ProviderProfileViewModel, router: RouterBase<HomeRouterTransitions>) {
        self.viewModel = viewModel
        self.router = router
        
        super.init(nibName: String(describing: ProviderProfileViewController.self), bundle: nil)
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
        
        if viewModel.dataSource.value.isEmpty {
            viewModel.fetchProfile()
        }
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        disableTitle()
        
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.registerNib(ProviderServiceCell.self)
        tableView.registerNib(ProviderProfileCell.self)
        tableView.registerNib(SelectorCell.self)
        tableView.registerNib(CommentCell.self)
        
        totalViewBottomConstraint.constant = -totalViewHeightConstraint.constant
        
        setupBindings()
    }
    
    private func setupBindings() {
        viewModel.dataSource.bindTo(tableView, to: .dataSource)
        
        viewModel.isLoading.observe = { [weak self] isLoading in
            guard let self = self else { return }
            isLoading ? Loader.show(in: self) : Loader.dismiss()
        }
        
        viewModel.formattedTotal.bindTo(totalLabel, to: .text)
    }
}

// MARK: - SelectorCellDelegate
extension ProviderProfileViewController: SelectorCellDelegate {
    func buttonTapped(at index: Int, title: String, button: MButton) {
        viewModel.toggleCommentsSection(with: index)
    }
}

// MARK: - ProviderServiceCellDelegate
extension ProviderProfileViewController: ProviderServiceCellDelegate {
    func cellTapped(_ cell: ProviderServiceCell, viewModel: ProviderServiceCellDataSource?) {
        guard let viewModel = viewModel as? ProductSelectorDataSource else {
            return
        }
        
        ProductSelector.show(in: self, viewModel: viewModel, delegate: self)
    }
}

// MARK: - ProductSelectorDelegate
extension ProviderProfileViewController: ProductSelectorDelegate {
    func productChanged(result: ProductSelectorResult) {}
    
    func cancelButtonTapped() {}
    
    func doneButtonTapped(result: ProductSelectorResult) {
        if !isTotalViewVisible {
            totalViewBottomConstraint.constant = 0
            
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
        
        viewModel.updateTotalForItem(identifier: result.identifier,
                                     total: result.total)
    }
}

// MARK: - UITableViewDataSource
extension ProviderProfileViewController: UITableViewDataSource {
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
