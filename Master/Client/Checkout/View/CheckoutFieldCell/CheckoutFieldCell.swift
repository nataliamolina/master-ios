//
//  CheckoutFieldView.swift
//  Master
//
//  Created by Carlos Mejía on 21/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

protocol CheckoutFieldCellDelegate: class {
    func cellTapped(_ cell: CheckoutFieldCell, viewModel: CheckoutFieldCellDataSource)
}

class CheckoutFieldCell: UITableViewCell, ConfigurableCellProtocol {
    // MARK: - UI References
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var detailImageView: UIImageView!

    // MARK: - Properties
    private weak var delegate: CheckoutFieldCellDelegate?
    private var viewModel: CheckoutFieldCellDataSource?
    
    // MARK: - Life Cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        setupUI()
    }
    
    // MARK: - Public Methods
    func setupWith(viewModel: Any?, indexPath: IndexPath?, delegate: Any?) {
        guard let viewModel = viewModel as? CheckoutFieldCellDataSource else {
            return
        }
        
        self.viewModel = viewModel
        self.delegate = delegate as? CheckoutFieldCellDelegate
        self.iconImageView.image = viewModel.image
        self.titleLabel.text = viewModel.title
        
        if !viewModel.value.isEmpty {
            self.valueLabel.text = viewModel.value
        }
        
        self.detailImageView.isHidden = !viewModel.detailIconVisible
        self.bottomView.isHidden = !viewModel.bottomLineVisible
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        titleLabel.text = nil
        iconImageView.image = nil
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellTapped)))
    }
    
    @objc private func cellTapped() {
        guard let viewModel = self.viewModel else {
            return
        }
        
        delegate?.cellTapped(self, viewModel: viewModel)
    }
}
