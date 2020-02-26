//
//  ProviderProfileCell.swift
//  Master
//
//  Created by Carlos Mejía on 16/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

protocol ProviderProfileCellDelegate: class {
    func cellTapped(_ cell: ProviderProfileCell)
}

class ProviderProfileCell: UITableViewCell, ConfigurableCellProtocol {
    // MARK: - UI References
    @IBOutlet private weak var photoImageView: MImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descLabel: UILabel!
    
    // MARK: - Properties
    private weak var delegate: ProviderProfileCellDelegate?
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        setupUI()
    }
    
    // MARK: - Public Methods
    func setupWith(viewModel: Any?, indexPath: IndexPath?, delegate: Any?) {
        guard let viewModel = viewModel as? ProviderProfileCellDataSource else {
            return
        }
        
        self.delegate = delegate as? ProviderProfileCellDelegate
        
        self.photoImageView.kf.setImage(with: URL(string: viewModel.photoUrl), placeholder: UIImage.avatar)
        self.nameLabel.text = viewModel.names
        self.descLabel.text = viewModel.description
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        photoImageView.kf.cancelDownloadTask()
        nameLabel.text = nil
        descLabel.text = nil
    }
}
