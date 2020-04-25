//
//  MenuTitleCell.swift
//  Master
//
//  Created by Carlos Mejía on 25/04/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

protocol MenuTitleCellDataSource {
    var title: MenuTitle { get }
    var isFirstItem: Bool { get }
}

class MenuTitleCell: UITableViewCell, ConfigurableCellProtocol {
    // MARK: - UI References
    @IBOutlet private weak var topConstraint: NSLayoutConstraint!
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: - Life Cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        topConstraint.constant = 30
        titleLabel = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Public Methods
    func setupWith(viewModel: Any?, indexPath: IndexPath?, delegate: Any?) {
        guard let viewModel = viewModel as? MenuTitleCellDataSource else {
            return
        }
        
        if viewModel.isFirstItem {
            topConstraint.constant = 0
        }
            
        titleLabel.text = viewModel.title.localized
    }
}
