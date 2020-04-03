//
//  ProviderOrderDetailViewController.swift
//  Master
//
//  Created by Carlos Mejía on 1/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class ProviderOrderDetailViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var paymentButton: MButton!
    
    // MARK: - UI Actions
    
    // MARK: - Properties
    private let router: RouterBase<ProviderRouterTransitions>
    private let viewModel: ProviderOrderDetailViewModel
    
    // MARK: - Life Cycle
    
    init(viewModel: ProviderOrderDetailViewModel, router: RouterBase<ProviderRouterTransitions>) {
        self.viewModel = viewModel
        self.router = router
        
        super.init(nibName: String(describing: ProviderOrderDetailViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Public Methods
    
    // MARK: - Private Methods
    private func setupUI() {
        // FIXME
        title = "Pedido"
        
        disableTitle()
        
        paymentButton.isHidden = true
        
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.registerNib(OrderDetailHeaderCell.self)
        tableView.registerNib(ProviderServiceCell.self)
        tableView.registerNib(CheckoutFieldCell.self)
        tableView.registerNib(ButtonCell.self)
        
        setupBindings()
        
        viewModel.fetchDetail()
    }
    
    private func setupBindings() {
        viewModel.formattedTotal.bindTo(totalLabel, to: .text)
        viewModel.dataSource.bindTo(tableView, to: .dataSource)
        
        viewModel.isLoading.listen { isLoading in
            isLoading ? Loader.show() : Loader.dismiss()
        }
    }
}

// MARK: - UITableViewDataSource
extension ProviderOrderDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.getWith(cellViewModel: viewModel.getViewModelAt(indexPath: indexPath),
                                 indexPath: indexPath,
                                 delegate: self)
    }
}

// MARK: - OrderDetailHeaderCellDelegate
extension ProviderOrderDetailViewController: OrderDetailHeaderCellDelegate {
    func actionButtonTapped(_ cell: OrderDetailHeaderCell, type: OrderDetailHeaderCellButtonType) {
        
    }
}

// MARK: - ButtonCellDelegate
extension ProviderOrderDetailViewController: ButtonCellDelegate {
    func cellTapped(_ cell: ButtonCell, viewModel: ButtonCellDataSource) {
        guard
            let whatsappURL = URL(string: Session.shared.helpUrl),
            UIApplication.shared.canOpenURL(whatsappURL) else {
                return
        }
        
        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
    }
}
