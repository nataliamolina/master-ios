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
        
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        setupUI()
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
        totalOrdersLabel.text = "\(Int(viewModel.totalOrders))"
        
        photoImageView.kf.setImage(with: URL(string: viewModel.imageUrl), placeholder: UIImage.avatar)
        
        bottomLineView.isHidden = viewModel.isLastItem
        
        self.delegate = delegate as? ProviderCellDelegate
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellTapped)))
    }
    
    private func setupUI() {
        photoImageView.kf.cancelDownloadTask()
        photoImageView.image = nil
        namesLabel.text = nil
        scoreLabel.text = nil
        totalOrdersLabel.text = nil
    }
    
    @objc private func cellTapped() {
        delegate?.cellTappped(self)
    }
}
