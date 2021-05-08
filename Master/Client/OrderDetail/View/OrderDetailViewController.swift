//
//  OrderDetailViewController.swift
//  Master
//
//  Created by Carlos Mejía on 1/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var paymentButton: MButton!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var chatViewShadow: UIView!
    
    // MARK: - UI Actions
    @IBAction private func paymentButtonAction() {
        router.transition(to: .payment(viewModel: viewModel.getPaymentViewModel()))
    }
    
    // MARK: - UI Actions
    @IBAction private func goToChatAction() {
        router.transition(to: .chat(viewModel: viewModel.getChatViewModel()))
    }
    
    // MARK: - Properties
    private let router: RouterBase<OrdersRouterTransitions>
    private let viewModel: OrderDetailViewModel
    
    // MARK: - Life Cycle
    
    init(viewModel: OrderDetailViewModel, router: RouterBase<OrdersRouterTransitions>) {
        self.viewModel = viewModel
        self.router = router
        
        super.init(nibName: String(describing: OrderDetailViewController.self), bundle: nil)
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
        
        chatView.clipsToBounds = true
        chatView.layer.cornerRadius = chatView.frame.width / 2
        chatViewShadow.clipsToBounds = true
        chatViewShadow.layer.cornerRadius = chatViewShadow.frame.width / 2
        
        setupBindings()
        
        viewModel.fetchDetail()
    }
    
    private func setupBindings() {
        viewModel.formattedTotal.bindTo(totalLabel, to: .text)
        viewModel.dataSource.bindTo(tableView, to: .dataSource)
        viewModel.pendingPayment.bindTo(paymentButton, to: .visibility)
        
        viewModel.isLoading.listen { isLoading in
            isLoading ? Loader.show() : Loader.dismiss()
        }
        
        viewModel.needsToRateOrder.listen { [weak self] needsToRateOrder in
            guard let self = self, needsToRateOrder else {
                return
            }
            
            self.router.transition(to: .rateOrder(viewModel: self.viewModel.getRateViewModel()))
        }
    }
}

// MARK: - UITableViewDataSource
extension OrderDetailViewController: UITableViewDataSource {
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
extension OrderDetailViewController: OrderDetailHeaderCellDelegate {
    func actionButtonTapped(_ cell: OrderDetailHeaderCell, position: OrderDetailHeaderCellButtonType, state: OrderStateType) {
        router.transition(to: .rateOrder(viewModel: viewModel.getRateViewModel()))
    }
}
