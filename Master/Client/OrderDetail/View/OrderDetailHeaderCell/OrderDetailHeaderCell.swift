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
    @IBOutlet private weak var orderMessageLabel: UILabel!
    @IBOutlet private weak var providerInfoView: UIView!
    
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
        
        resetButtons()
        
        self.state = viewModel.status
        self.delegate = delegate as? OrderDetailHeaderCellDelegate
        
        self.orderIdLabel.text = Lang.orderId + viewModel.orderId.asString
        self.orderDateLabel.text = viewModel.orderDate
        self.providerNameLabel.text = viewModel.providerName
        
        statusHelper.setupLabel(statusLabel, state: viewModel.status)
        statusHelper.setupView(statusView, state: viewModel.status)
        providerInfoView.isHidden = viewModel.isProvider
        
        setupButtonsWith(state: viewModel.status, isProvider: viewModel.isProvider)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        orderIdLabel.text = nil
        statusLabel.text = nil
        providerNameLabel.text = nil
        orderDateLabel.text = nil
        orderMessageLabel.isHidden = true
    }
    
    private func setupButtonsWith(state: OrderStateType, isProvider: Bool) {
        switch state {
        case .ratingPending:
            guard !isProvider else {
                hiddeButtons()
                
                return
            }
            
            rightActionButton.isHidden = true
            
            leftActionButton.isHidden = false
            leftActionButton.style = .redBorder
            leftActionButton.title = "orderDetail.rate".localized
            
        case .pending:
            guard isProvider else {
                hiddeButtons()
                
                return
            }
            
            // FIXME: Move this to other method and fix strings
            leftActionButton.style = .fullRed
            leftActionButton.title = "Rechazar Servicio"
            
            rightActionButton.style = .green
            rightActionButton.title = "Aceptar Servicio"
            orderMessageLabel.isHidden = false
            
        case .paymentDone:
            guard isProvider else {
                hiddeButtons()
                
                return
            }
            
            rightActionButton.isHidden = true
            leftActionButton.style = .green
            leftActionButton.title = "Iniciar Servicio"
            
        case .inProgress:
            guard isProvider else {
                hiddeButtons()
                
                return
            }
            
            rightActionButton.isHidden = true
            leftActionButton.style = .fullRed
            leftActionButton.title = "Finalziar Servicio"
            
        default:
            hiddeButtons()
        }
    }
    
    private func hiddeButtons() {
        buttonsStackview.isHidden = true
        leftActionButton.isHidden = true
        rightActionButton.isHidden = true
    }
    
    private func resetButtons() {
        buttonsStackview.isHidden = false
        leftActionButton.isHidden = false
        rightActionButton.isHidden = false
    }
}
