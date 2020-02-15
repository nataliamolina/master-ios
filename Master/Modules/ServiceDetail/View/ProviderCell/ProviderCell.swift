//
//  ProviderCell.swift
//  Master
//
//  Created by Carlos Mejía on 15/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

protocol ProviderCellDelegate: class {
    func cellTappped(_ cell: ProviderCell)
}

class ProviderCell: UITableViewCell, ConfigurableCellProtocol {
    // MARK: - UI References
    @IBOutlet private weak var namesLabel: UILabel!
    @IBOutlet private weak var descLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var scoreIconImageView: UIImageView!
    @IBOutlet private weak var totalOrdersLabel: UILabel!
    @IBOutlet private weak var totalOrdersTextLabel: UILabel!
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var bottomLineView: UIView!
    
    // MARK: - Properties
    private weak var delegate: ProviderCellDelegate?
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoImageView.kf.cancelDownloadTask()
        photoImageView.image = nil
    }
    
    // MARK: - Public Methods
    
    func setupWith(viewModel: Any?, indexPath: IndexPath?, delegate: Any?) {
        guard let viewModel = viewModel as? ProviderCellDataSource else {
            return
        }
        
        namesLabel.text = viewModel.names
        descLabel.text = viewModel.desc.trimmingCharacters(in: .whitespacesAndNewlines)
        
        scoreIconImageView.isHidden = viewModel.score <= 0
        scoreLabel.isHidden = viewModel.score <= 0
        scoreLabel.text = "\(viewModel.score)"
        
        totalOrdersTextLabel.isHidden = viewModel.totalOrders <= 0
        totalOrdersLabel.isHidden = viewModel.totalOrders <= 0
        totalOrdersLabel.text = "\(viewModel.totalOrders)"
        
        photoImageView.layer.cornerRadius = photoImageView.frame.width / 2
        photoImageView.layer.borderColor = UIColor.Master.green.cgColor
        photoImageView.layer.borderWidth = 2
        photoImageView.clipsToBounds = true
        photoImageView.kf.setImage(with: URL(string: viewModel.imageUrl))
        
        bottomLineView.isHidden = viewModel.isLastItem
        
        self.delegate = delegate as? ProviderCellDelegate
    }
}
