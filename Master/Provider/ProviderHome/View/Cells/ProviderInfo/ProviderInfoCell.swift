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

class ProviderInfoCell: UITableViewCell, ConfigurableCellProtocol {
    // MARK: - UI References
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var placeLabel: UILabel!
    
    // MARK: - Properties
    private let statusHelper = StatusHelper()
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
        
        titleLabel.text = viewModel.title
        subTitleLabel.text = viewModel.subTitle
        placeLabel.text = "\(viewModel.city) - \(viewModel.country)"
        
        let date = viewModel.isCurrent ? "providerInfo.current".localized : viewModel.endDateShow
        
       dateLabel.text = "\(viewModel.startDateShow) - \(date) "
    }
}
