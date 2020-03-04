//
//  OrdersViewController.swift
//  Master
//
//  Created by Carlos Mejía on 29/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class OrdersViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private let router: RouterBase<OrdersRouterTransitions>
    private var viewModel: OrdersViewModel = {
        return OrdersViewModel()
    }()
    
    // MARK: - Life Cycle
    init(router: RouterBase<OrdersRouterTransitions>) {
        self.router = router
        
        super.init(nibName: String(describing: OrdersViewController.self), bundle: nil)
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
        disableTitle()
        
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.registerNib(TitleCell.self)
        tableView.registerNib(OrderCell.self)
        
        setupBindings()
        
        viewModel.fetchServices()
    }
    
    private func setupBindings() {
        viewModel.dataSource.bindTo(tableView, to: .dataSource)
        
        viewModel.isLoading.listen { isLoading in
            isLoading ? Loader.show() : Loader.dismiss()
        }
    }
}

// MARK: - OrderCellDelegate
extension OrdersViewController: OrderCellDelegate {
    func cellTapped(_ cell: OrderCell, viewModel: OrderCellDataSource) {
        let orderDetailViewModel = self.viewModel.getOrderDetailViewModel(with: viewModel)
        
        router.transition(to: .orderDetail(viewModel: orderDetailViewModel))
    }
}

// MARK: - UITableViewDataSource
extension OrdersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.getWith(cellViewModel: viewModel.getViewModelAt(indexPath: indexPath),
                                 indexPath: indexPath,
                                 delegate: self)
    }
}
