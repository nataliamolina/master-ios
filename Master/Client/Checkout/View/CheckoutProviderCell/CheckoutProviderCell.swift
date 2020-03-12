//
//  CheckoutProviderCell.swift
//  Master
//
//  Created by Carlos Mejía on 24/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class CheckoutProviderCell: UITableViewCell, ConfigurableCellProtocol {
    // MARK: - UI References
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descLabel: UILabel!
    @IBOutlet private weak var photoImageView: UIImageView!
    
    // MARK: - Properties
    private var viewModel: CheckoutProviderCellDataSource?
    
    // MARK: - Life Cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        setupUI()
    }
    
    // MARK: - Public Methods
    func setupWith(viewModel: Any?, indexPath: IndexPath?, delegate: Any?) {
        guard let viewModel = viewModel as? CheckoutProviderCellDataSource else {
            return
        }
        
        self.nameLabel.text = viewModel.name
        self.descLabel.text = viewModel.description
        self.photoImageView.kf.setImage(with: URL(string: viewModel.photoUrl), placeholder: UIImage.avatar)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        nameLabel.text = nil
        descLabel.text = nil
        
        photoImageView.kf.cancelDownloadTask()
        photoImageView.image = nil
    }
}
