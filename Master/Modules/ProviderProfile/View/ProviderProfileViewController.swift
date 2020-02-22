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
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var totalView: UIView!
    @IBOutlet private weak var totalLabel: UILabel!
    
    // MARK: - UI Actions
    @IBAction private func continueButtonAction() {
    }
    
    // MARK: - Properties
    private let viewModel: ProviderProfileViewModel
    
    // MARK: - Life Cycle
    
    init(viewModel: ProviderProfileViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: String(describing: ProviderProfileViewController.self), bundle: nil)
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
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.registerNib(ProviderServiceCell.self)
        tableView.registerNib(ProviderProfileCell.self)
        tableView.registerNib(SelectorCell.self)
        tableView.registerNib(CommentCell.self)
        
        totalView.isHidden = true
        
        setupBindings()
        
        viewModel.fetchProfile()
    }
    
    private func setupBindings() {
        viewModel.dataSource.bindTo(tableView, to: .dataSource)
        viewModel.isLoading.bindTo(activityIndicator, to: .state)
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
        print(result)
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
