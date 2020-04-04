//
//  OrderDetailHeaderCell.swift
//  Master
//
//  Created by Carlos Mejía on 1/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

enum OrderDetailHeaderCellButtonType {
    case left
    case right
}

protocol OrderDetailHeaderCellDelegate: class {
    func actionButtonTapped(_ cell: OrderDetailHeaderCell, position: OrderDetailHeaderCellButtonType, state: OrderStateType)
}

private struct Lang {
    static let orderId = "orderDetail.title".localized
}

class OrderDetailHeaderCell: UITableViewCell, ConfigurableCellProtocol {
    // MARK: - UI References
    @IBOutlet private weak var buttonsStackview: UIStackView!
    @IBOutlet private weak var orderIdLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var statusView: UIView!
    @IBOutlet private weak var leftActionButton: MButton!
    @IBOutlet private weak var rightActionButton: MButton!
    @IBOutlet private weak var providerNameLabel: UILabel!
    @IBOutlet private weak var orderDateLabel: UILabel!
    
    // MARK: - UI Actions
    @IBAction private func leftButtonAction() {
        delegate?.actionButtonTapped(self, position: .left, state: state)
    }
    
    @IBAction private func rightButtonAction() {
        delegate?.actionButtonTapped(self, position: .right, state: state)
    }
    
    // MARK: - Properties
    private var state: OrderStateType = .unknown
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
        
        self.state = viewModel.status
        self.delegate = delegate as? OrderDetailHeaderCellDelegate
        
        self.orderIdLabel.text = Lang.orderId + viewModel.orderId.asString
        self.orderDateLabel.text = viewModel.orderDate
        self.providerNameLabel.text = viewModel.providerName
        
        statusHelper.setupLabel(statusLabel, state: viewModel.status)
        statusHelper.setupView(statusView, state: viewModel.status)
        
        switch viewModel.status {
        case .ratingPending:
            rightActionButton.isHidden = true
            rightActionButton.title = "orderDetail.rate".localized
            
        case .pending:
            guard viewModel.isProvider else {
                hiddeButtons()
                
                return
            }
            
            // FIXME: Move this to other method and fix strings
            leftActionButton.style = .fullRed
            leftActionButton.title = "Rechazar Servicio"
            
            rightActionButton.style = .green
            rightActionButton.title = "Aceptar Servicio"
            
        default:
            hiddeButtons()
        }
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        orderIdLabel.text = nil
        statusLabel.text = nil
        providerNameLabel.text = nil
        orderDateLabel.text = nil
    }
    
    private func hiddeButtons() {
        buttonsStackview.isHidden = true
        leftActionButton.isHidden = true
        rightActionButton.isHidden = true
    }
}
