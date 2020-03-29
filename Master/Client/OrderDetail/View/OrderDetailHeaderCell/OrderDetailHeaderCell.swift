//
//  OrderDetailHeaderCell.swift
//  Master
//
//  Created by Carlos Mejía on 1/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

protocol OrderDetailHeaderCellDelegate: class {
    func actionButtonTapped(_ cell: OrderDetailHeaderCell)
}

private struct Lang {
    static let orderId = "orderDetail.title".localized
}

class OrderDetailHeaderCell: UITableViewCell, ConfigurableCellProtocol {
    // MARK: - UI References
    @IBOutlet private weak var orderIdLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var statusView: UIView!
    @IBOutlet private weak var mainActionButton: MButton!
    @IBOutlet private weak var providerNameLabel: UILabel!
    @IBOutlet private weak var orderDateLabel: UILabel!
    
    // MARK: - UI Actions
    @IBAction private func mainButtonAction() {
        delegate?.actionButtonTapped(self)
    }
    
    // MARK: - Properties
    private let statusHelper = StatusHelper()
    private weak var delegate: OrderDetailHeaderCellDelegate?
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - Public Methods
    func setupWith(viewModel: Any?, indexPath: IndexPath?, delegate: Any?) {
        guard let viewModel = viewModel as? OrderDetailHeaderCellDataSource else {
            return
        }
        
        self.delegate = delegate as? OrderDetailHeaderCellDelegate
        
        self.orderIdLabel.text = Lang.orderId + viewModel.orderId.asString
        self.orderDateLabel.text = viewModel.orderDate
        self.providerNameLabel.text = viewModel.providerName
        
        statusHelper.setupLabel(statusLabel, state: viewModel.status)
        statusHelper.setupView(statusView, state: viewModel.status)
        
        mainActionButton.isHidden = !viewModel.showMainButton
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        orderIdLabel.text = nil
        statusLabel.text = nil
        providerNameLabel.text = nil
        orderDateLabel.text = nil
    }
}