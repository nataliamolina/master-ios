//
//  OrderCell.swift
//  Master
//
//  Created by Carlos Mejía on 29/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

protocol OrderCellDelegate: class {
    func cellTapped(_ cell: OrderCell, viewModel: OrderCellDataSource)
}

class OrderCell: UITableViewCell, ConfigurableCellProtocol {
    // MARK: - UI References
    @IBOutlet private weak var idLabel: UILabel!
    @IBOutlet private weak var providerNameLabel: UILabel!
    @IBOutlet private weak var orderTotalLabel: UILabel!
    @IBOutlet private weak var orderCategoryLabel: UILabel!
    @IBOutlet private weak var orderStateLabel: UILabel!
    @IBOutlet private weak var providerImageView: UIImageView!
    @IBOutlet private weak var bottomView: UIView!
    
    // MARK: - Properties
    private let statusHelper = StatusHelper()
    private weak var delegate: OrderCellDelegate?
    private var viewModel: OrderCellDataSource?
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - Public Methods
    func setupWith(viewModel: Any?, indexPath: IndexPath?, delegate: Any?) {
        guard let viewModel = viewModel as? OrderCellDataSource else {
            return
        }
        
        self.viewModel = viewModel
        self.delegate = delegate as? OrderCellDelegate
        
        idLabel.text = "#" + viewModel.id
        providerNameLabel.text = viewModel.providerName
        orderTotalLabel.text = viewModel.orderTotal.toFormattedCurrency()
        orderCategoryLabel.text = viewModel.orderCategory
        providerImageView.kf.setImage(with: URL(string: viewModel.providerImageUrl), placeholder: UIImage.avatar)
        bottomView.isHidden = viewModel.isLastItem
        
        statusHelper.setupLabel(orderStateLabel, state: viewModel.orderState)
        
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
