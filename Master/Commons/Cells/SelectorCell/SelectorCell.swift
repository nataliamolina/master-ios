//
//  SelectorCell.swift
//  Master
//
//  Created by Carlos Mejía on 16/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

protocol SelectorCellDelegate: class {
    func buttonTapped(at index: Int, title: String, button: MButton)
}

class SelectorCell: UITableViewCell, ConfigurableCellProtocol {
    // MARK: - UI References
    @IBOutlet private weak var stackView: UIStackView!
    
    // MARK: - Properties
    private weak var delegate: SelectorCellDelegate?
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        setupUI()
    }
    
    // MARK: - Public Methods
    func setupWith(viewModel: Any?, indexPath: IndexPath?, delegate: Any?) {
        guard let viewModel = viewModel as? SelectorCellDataSource else {
            return
        }
        
        self.delegate = delegate as? SelectorCellDelegate
        
        viewModel.buttons.enumerated().forEach { (index, item) in
            let button = MButton()
            button.style = item.style
            button.title = item.title
            button.tag = index
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            
            stackView.addArrangedSubview(button)
        }
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    @objc private func buttonTapped(_ button: MButton) {
        delegate?.buttonTapped(at: button.tag, title: button.titleLabel?.text ?? "", button: button)
    }
}
