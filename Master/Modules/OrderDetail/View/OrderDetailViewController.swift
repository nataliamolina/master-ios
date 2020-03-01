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
    
    // MARK: - Properties
    private let viewModel: OrderDetailViewModel
    
    // MARK: - Life Cycle
    
    init(viewModel: OrderDetailViewModel) {
        self.viewModel = viewModel
        
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
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.registerNib(OrderDetailHeaderCell.self)
        tableView.registerNib(ProviderServiceCell.self)
        tableView.registerNib(CheckoutFieldCell.self)

        setupBindings()
        
        viewModel.fetchDetail()
    }
    
    private func setupBindings() {
        viewModel.dataSource.bindTo(tableView, to: .dataSource)
        
        viewModel.isLoading.listen { isLoading in
            isLoading ? Loader.show() : Loader.dismiss()
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
