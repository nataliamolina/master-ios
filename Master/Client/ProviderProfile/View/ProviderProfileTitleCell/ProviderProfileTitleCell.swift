//
//  ProviderProfileTitleCell.swift
//  Master
//
//  Created by Maria Paula Gomez Prieto on 7/2/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

protocol ProviderProfileTitleCellDelegate: class {
    func addInfoCellTapped(_ cell: ProviderProfileTitleCell, viewModel: ProviderProfileTitleViewModel)
}
class ProviderProfileTitleCell: UITableViewCell, ConfigurableCellProtocol {
    // MARK: - UI References
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: - UI Actions
    @IBAction private func addInfoAction() {
        guard let viewModel = viewModel else { return }
        delegate?.addInfoCellTapped(self, viewModel: viewModel)
    }
    
    // MARK: - Properties
    private weak var delegate: ProviderProfileTitleCellDelegate?
    private var viewModel: ProviderProfileTitleViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupWith(viewModel: Any?, indexPath: IndexPath?, delegate: Any?) {
        guard let viewModel = viewModel as? ProviderProfileTitleViewModel else {
            return
        }
        self.viewModel = viewModel
        self.delegate = delegate as? ProviderProfileTitleCellDelegate
        titleLabel.text = viewModel.title
        addButton.isHidden = !viewModel.showButton
    }
}
