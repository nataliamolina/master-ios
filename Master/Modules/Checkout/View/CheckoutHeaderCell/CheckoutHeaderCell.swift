//
//  CheckoutHeaderCell.swift
//  Master
//
//  Created by Carlos Mejía on 24/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

protocol CheckoutHeaderCellDelegate: class {
    func cellTapped(_ cell: CheckoutHeaderCell, viewModel: CheckoutHeaderCellDataSource)
}

class CheckoutHeaderCell: UITableViewCell, ConfigurableCellProtocol {
    // MARK: - UI References
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    // MARK: - Properties
    private weak var delegate: CheckoutHeaderCellDelegate?
    private var viewModel: CheckoutHeaderCellDataSource?
    
    // MARK: - Life Cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        setupUI()
    }
    
    // MARK: - Public Methods
    func setupWith(viewModel: Any?, indexPath: IndexPath?, delegate: Any?) {
        guard let viewModel = viewModel as? CheckoutHeaderCellDataSource else {
            return
        }
        
        self.viewModel = viewModel
        self.delegate = delegate as? CheckoutHeaderCellDelegate
        self.titleLabel.text = viewModel.title
        self.priceLabel.text = viewModel.value
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        titleLabel.text = nil
        priceLabel.text = nil
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellTapped)))
    }
    
    @objc private func cellTapped() {
        guard let viewModel = self.viewModel else {
            return
        }
        
        delegate?.cellTapped(self, viewModel: viewModel)
    }
}
