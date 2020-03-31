//
//  ProviderOrderCell.swift
//  Master
//
//  Created by Carlos Mejía on 30/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

protocol ProviderOrderCellDelegate: class {
    func cellTapped(_ cell: ProviderOrderCell, viewModel: ProviderOrderCellDataSource)
}

class ProviderOrderCell: UITableViewCell, ConfigurableCellProtocol {
    // MARK: - UI References
    @IBOutlet private weak var idLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var orderCategoryLabel: UILabel!
    @IBOutlet private weak var orderStateLabel: UILabel!
    @IBOutlet private weak var orderStateView: UIView!
    @IBOutlet private weak var bottomView: UIView!
    
    // MARK: - Properties
    private let statusHelper = StatusHelper()
    private weak var delegate: ProviderOrderCellDelegate?
    private var viewModel: ProviderOrderCellDataSource?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Public Methods
    func setupWith(viewModel: Any?, indexPath: IndexPath?, delegate: Any?) {
        guard let viewModel = viewModel as? ProviderOrderCellDataSource else {
            return
        }
        
        self.viewModel = viewModel
        self.delegate = delegate as? ProviderOrderCellDelegate
        
        idLabel.text = "orderDetail.title".localized + viewModel.id
        userNameLabel.text = viewModel.userName
        orderCategoryLabel.text = viewModel.orderCategory
        bottomView.isHidden = viewModel.isLastItem
        
        statusHelper.setupLabel(orderStateLabel, state: viewModel.orderState)
        statusHelper.setupView(orderStateView, state: viewModel.orderState)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellTapped)))
    }
    
    @objc private func cellTapped() {
        guard let viewModel = viewModel else {
            return
        }
        
        delegate?.cellTapped(self, viewModel: viewModel)
    }
    
}
