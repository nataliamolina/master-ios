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
        
        idLabel.text = "#" + viewModel.id
        providerNameLabel.text = viewModel.providerName
        orderTotalLabel.text = viewModel.orderTotal.toFormattedCurrency()
        orderCategoryLabel.text = viewModel.orderCategory
        providerImageView.kf.setImage(with: URL(string: viewModel.providerImageUrl), placeholder: UIImage.avatar)
        bottomView.isHidden = viewModel.isLastItem
        
        setupLabelState(viewModel.orderState)
        
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        orderStateLabel.clipsToBounds = true
        orderStateLabel.layer.cornerRadius = 10
        orderStateLabel.textColor = .white
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellTapped)))
    }
    
    @objc private func cellTapped() {
        guard let viewModel = viewModel else {
            return
        }
        
        delegate?.cellTapped(self, viewModel: viewModel)
    }
    
    private func setupLabelState(_ state: OrderStateType) {
        orderStateLabel.backgroundColor = styles[state]
        orderStateLabel.text = stateName[state]
    }
    
    private let styles: [OrderStateType: UIColor] = [
        .accepted: UIColor.Master.green,
        .finished: UIColor.Master.green,
        .inProgress: UIColor.Master.yellow,
        .rejected: UIColor.Master.red,
        .pending: UIColor.Master.yellow,
        .pendingForPayment: UIColor.Master.yellow,
        .paymentDone: UIColor.Master.green
    ]

    private let stateName: [OrderStateType: String] = [
        .accepted: "general.state.acepted".localized,
        .finished: "general.state.finished".localized,
        .inProgress: "general.state.inProgress".localized,
        .rejected: "general.state.rejected".localized,
        .pending: "general.state.pending".localized,
        .pendingForPayment: "general.state.paymentPending".localized,
        .paymentDone: "general.state.paymentDone".localized
    ]
}
