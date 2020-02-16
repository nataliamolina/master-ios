//
//  ProviderServiceCell.swift
//  Master
//
//  Created by Carlos Mejía on 16/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

protocol ProviderServiceCellDelegate: class {
    func cellTapped(_ cell: ProviderServiceCell)
}

class ProviderServiceCell: UITableViewCell, ConfigurableCellProtocol {
    // MARK: - UI References
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var productPriceLabel: UILabel!
    @IBOutlet private weak var productDescLabel: UILabel!
    @IBOutlet private weak var productCountLabel: UILabel!
    
    // MARK: - Properties
    private weak var delegate: ProviderServiceCellDelegate?
    
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
        guard let viewModel = viewModel as? ProviderServiceCellDataSource else {
            return
        }
        
        self.productImageView.kf.setImage(with: URL(string: viewModel.productImageUrl))
        self.productNameLabel.text = viewModel.productName
        self.productPriceLabel.text = viewModel.productPrice.toFormattedCurrency(withSymbol: false)
        self.productDescLabel.text = viewModel.productDesc
        self.productCountLabel.text = viewModel.productCount.asString
        
        self.delegate = delegate as? ProviderServiceCellDelegate
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        productCountLabel.backgroundColor = UIColor.Master.green
        productCountLabel.textColor = .white
        productCountLabel.layer.cornerRadius = productCountLabel.frame.width / 2
        productCountLabel.clipsToBounds = true
        
        productImageView.layer.cornerRadius = 12
        productImageView.kf.cancelDownloadTask()
        productImageView.image = nil
    }
}
