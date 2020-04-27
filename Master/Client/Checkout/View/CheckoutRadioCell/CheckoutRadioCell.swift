//
//  CheckoutRadioCell.swift
//  Master
//
//  Created by Carlos Mejía on 26/04/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

protocol CheckoutRadioCellDelegate: class {
    func cellTapped(_ cell: CheckoutRadioCell, option: RadioOption)
}

class CheckoutRadioCell: UITableViewCell, ConfigurableCellProtocol {
    // MARK: - UI References
    @IBOutlet private weak var stackView: UIStackView!
    
    // MARK: - Properties
    private weak var delegate: CheckoutRadioCellDelegate?
    private var viewModel: CheckoutRadioCellDataSource?
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    // MARK: - Public Methods
    func setupWith(viewModel: Any?, indexPath: IndexPath?, delegate: Any?) {
        guard let viewModel = viewModel as? CheckoutRadioCellDataSource else {
            return
        }
        
        self.viewModel = viewModel
        self.delegate = delegate as? CheckoutRadioCellDelegate
        
        for (index, item) in viewModel.options.enumerated() {
            let radioView: RadioView = .fromNib()
            radioView.setupWith(name: item.name, isSelected: (item.value as? Bool) ?? false, index: index)
            radioView.onTappedBlock = { [weak self] index in
                self?.notifyOptionSelected(at: index)
            }
            
            stackView.addArrangedSubview(radioView)
        }
    }
    
    // MARK: - Private Methods
    private func notifyOptionSelected(at index: Int) {
        guard let optionSelected = viewModel?.options.safeContains(index) else {
            return
        }
        
        for optionIndex in (viewModel?.options ?? []).indices {
            viewModel?.options[optionIndex].value = index == optionIndex
            
            let view = (stackView.arrangedSubviews[optionIndex] as? RadioView)
            let option = viewModel?.options[optionIndex]
            let isSelected = (option?.value as? Bool) ?? false
            
            view?.setupWith(name: option?.name ?? "", isSelected: isSelected, index: optionIndex)
        }
        
        delegate?.cellTapped(self, option: optionSelected)
    }
}
