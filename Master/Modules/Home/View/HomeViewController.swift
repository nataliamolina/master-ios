//
//  HomeViewController.swift
//  Master
//
//  Created by Luis Carlos Mejia Garcia on 12/26/19.
//  Copyright © 2019 Master. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    private var dataSource: [CellViewModelProtocol] = []
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.registerNib(CategoryCell.self)
        
        setupMenuIcon()
        setupLogoIcon()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        dataSource = [
            CategoryCellViewModel(imageUrl: "https://about.canva.com/es_co/wp-content/uploads/sites/3/2015/02/Etsy-Banners.png"),
            CategoryCellViewModel(imageUrl: "https://about.canva.com/es_co/wp-content/uploads/sites/3/2015/02/Etsy-Banners.png"),
            CategoryCellViewModel(imageUrl: "https://about.canva.com/es_co/wp-content/uploads/sites/3/2015/02/Etsy-Banners.png"),
            CategoryCellViewModel(imageUrl: "https://about.canva.com/es_co/wp-content/uploads/sites/3/2015/02/Etsy-Banners.png"),
            CategoryCellViewModel(imageUrl: "https://about.canva.com/es_co/wp-content/uploads/sites/3/2015/02/Etsy-Banners.png")
        ]
        
        
        tableView.reloadData()
    }
    
    // MARK: - Private Methods
    private func setupMenuIcon() {
        let leftImage = UIBarButtonItem(image: .menu, style: .plain, target: #selector(menuButtonTapped), action: nil)
        leftImage.tintColor = .black
        navigationItem.leftBarButtonItem = leftImage
    }
    
    private func setupLogoIcon() {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .greenLogoIcon
        
        navigationItem.titleView = imageView
    }
    
    @objc private func menuButtonTapped() {
        
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
