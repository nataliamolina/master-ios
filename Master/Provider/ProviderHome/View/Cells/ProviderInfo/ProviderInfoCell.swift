//
//  ProviderInfoCell.swift
//  Master
//
//  Created by Maria Paula Gomez Prieto on 6/30/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

enum ProviderInfoType: String, Codable {
    case study
    case experience
    case none
}

protocol ProviderInfoCellDelegate: class {
    func editCellTapped(_ cell: ProviderInfoCell, viewModel: ProviderInfoCellDataSource)
}

class ProviderInfoCell: UITableViewCell, ConfigurableCellProtocol {
    // MARK: - UI References
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var placeLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!
    
    // MARK: - UI Actions
    @IBAction private func editInfoAction() {
        guard let viewModel = viewModel else { return }
        delegate?.editCellTapped(self, viewModel: viewModel)
    }
    
    // MARK: - Properties
    private let statusHelper = StatusHelper()
    private weak var delegate: ProviderInfoCellDelegate?
    private var viewModel: ProviderInfoCellDataSource?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        subTitleLabel.text = nil
        dateLabel.text = nil
        placeLabel.text = nil
    }
    
    // MARK: - Public Methods
    func setupWith(viewModel: Any?, indexPath: IndexPath?, delegate: Any?) {
        guard let viewModel = viewModel as? ProviderInfoCellDataSource else {
            return
        }
        
        self.viewModel = viewModel
        self.delegate = delegate as? ProviderInfoCellDelegate
        
        titleLabel.text = viewModel.title
        subTitleLabel.text = viewModel.subTitle
        dateLabel.text = "\(viewModel.startDate) - \(viewModel.finishDate) "
        placeLabel.text = "\(viewModel.city) - \(viewModel.country)"
        editButton.isHidden = !viewModel.isProvider
    }
}
