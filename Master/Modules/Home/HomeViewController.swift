//
//  HomeViewController.swift
//  Master
//
//  Created by Luis Carlos Mejia Garcia on 12/26/19.
//  Copyright © 2019 Master. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private var dataSource: [IdentificableViewModelProtocol] {
        return [
            CategoryCellViewModel(imageUrl: ""),
            CategoryCellViewModel(imageUrl: ""),
            CategoryCellViewModel(imageUrl: ""),
            CategoryCellViewModel(imageUrl: ""),
            CategoryCellViewModel(imageUrl: "")
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.registerNib(CategoryCell.self)
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = dataSource.safeContains(indexPath.row)
        let identifier = viewModel?.identifier ?? ""
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        (cell as? ConfigurableCellProtocol)?.setupWith(viewModel: viewModel, indexPath: indexPath, delegate: nil)
        
        return cell
    }
}
