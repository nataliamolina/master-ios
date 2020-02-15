//
//  ServiceDetailViewController.swift
//  Master
//
//  Created by Carlos Mejía on 15/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class ServiceDetailViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerImage: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private let viewModel: ServiceDetailViewModel
    
    // MARK: - Life Cycle
    init(viewModel: ServiceDetailViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: String(describing: ServiceDetailViewController.self), bundle: nil)
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
        headerImage.kf.setImage(with: URL(string: viewModel.serviceImageUrl ?? ""))
        
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.registerNib(ProviderCell.self)
        
        viewModel.fetchDetail()
        
        setupBindings()
    }
    
    private func setupBindings() {
        viewModel.dataSource.bindTo(tableView, to: .dataSource)
        viewModel.isLoading.bindTo(activityIndicator, to: .state)
    }
}

// MARK: - UITableViewDataSource
extension ServiceDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.getWith(cellViewModel: viewModel.getViewModelAt(indexPath: indexPath),
                                 indexPath: indexPath,
                                 delegate: self)
    }
}