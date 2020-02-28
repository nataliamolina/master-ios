//
//  ButtonCell.swift
//  Master
//
//  Created by Carlos Mejía on 24/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

protocol ButtonCellDelegate: class {
    func cellTapped(_ cell: ButtonCell, viewModel: ButtonCellDataSource)
}

class ButtonCell: UITableViewCell, ConfigurableCellProtocol {
    // MARK: - UI References
    @IBOutlet weak var mainButton: MButton!
    
    // MARK: - UI Actions
    @IBAction private func buttonAction() {
        cellTapped()
    }
    
    // MARK: - Properties
    private weak var delegate: ButtonCellDelegate?
    private var viewModel: ButtonCellDataSource?

    // MARK: - Life Cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        setupUI()
    }
    
    // MARK: - Public Methods
    func setupWith(viewModel: Any?, indexPath: IndexPath?, delegate: Any?) {
        guard let viewModel = viewModel as? ButtonCellDataSource else {
            return
        }
        
        self.viewModel = viewModel
        self.delegate = delegate as? ButtonCellDelegate
        self.mainButton.style = viewModel.style
        
        self.mainButton.setTitle(viewModel.title, for: .normal)
        self.mainButton.setTitle(viewModel.title, for: .selected)
        self.mainButton.setTitle(viewModel.title, for: .focused)
        self.mainButton.setTitle(viewModel.title, for: .application)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
    }
    
    private func cellTapped() {
        guard let viewModel = self.viewModel else {
            return
        }
        
        delegate?.cellTapped(self, viewModel: viewModel)
    }
}
