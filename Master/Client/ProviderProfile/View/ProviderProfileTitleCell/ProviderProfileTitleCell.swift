//
//  ProviderProfileTitleCell.swift
//  Master
//
//  Created by Maria Paula Gomez Prieto on 7/2/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class ProviderProfileTitleCell: UITableViewCell {
    // MARK: - UI References
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setViewWith(viewModel: ProviderProfileTitleViewModel) {
        titleLabel.text = viewModel.title
        addButton.isHidden = !viewModel.showButton
    }
}
