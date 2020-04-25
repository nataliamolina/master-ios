//
//  MenuOptionCell.swift
//  Master
//
//  Created by Carlos Mejía on 25/04/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

protocol MenuOptionCellDataSource {
    var option: MenuOption { get }
}

protocol MenuOptionCellDelegate: class {
    func optionTapped(_ option: MenuOption)
}

class MenuOptionCell: UITableViewCell, ConfigurableCellProtocol {
    // MARK: - UI References
    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var iconImageView: UIImageView!
    
    // MARK: - UI Actions
    @IBAction private func buttonAction() {
        guard let optionSelected = viewModel?.option else { return }
        
        delegate?.optionTapped(optionSelected)
    }
    
    // MARK: - Properties
    private weak var delegate: MenuOptionCellDelegate?
    private var viewModel: MenuOptionCellDataSource?
    
    // MARK: - Life Cycle

    override func prepareForReuse() {
        super.prepareForReuse()
        
        button.title = nil
        iconImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Public Methods
    func setupWith(viewModel: Any?, indexPath: IndexPath?, delegate: Any?) {
        guard let viewModel = viewModel as? MenuOptionCellDataSource else {
            return
        }
        
        self.delegate = delegate as? MenuOptionCellDelegate
        self.viewModel = viewModel
        
        button.title = viewModel.option.localized
        iconImageView.image = viewModel.option.icon
    }
}
