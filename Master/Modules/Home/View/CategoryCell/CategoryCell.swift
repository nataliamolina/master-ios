//
//  CategoryCell.swift
//  Master
//
//  Created by Luis Carlos Mejia Garcia on 12/26/19.
//  Copyright © 2019 Master. All rights reserved.
//

import UIKit
import Kingfisher

protocol CategoryCellDataSource {
    var imageUrl: String { get }
}

protocol CategoryCellDelegate: class {
    func cellTapped(_ cell: CategoryCell)
}

class CategoryCell: MAnimatedTableViewCell, ConfigurableCellProtocol {
    // MARK: - UI References
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var categoryImageView: UIImageView!
    
    // MARK: - Properties
    private weak var delegate: CategoryCellDelegate?

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        categoryImageView.kf.cancelDownloadTask()
    }

    // MARK: - Public Methods
    func setupWith(viewModel: Any?, indexPath: IndexPath?, delegate: Any?) {
        guard let viewModel = viewModel as? CategoryCellDataSource else {
            return
        }
        
        self.delegate = delegate as? CategoryCellDelegate
        
        setupUI()
        
        categoryImageView.kf.setImage(with: URL(string: viewModel.imageUrl))
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellTapped)))
    }
    
    @objc private func cellTapped() {
        delegate?.cellTapped(self)
    }
}
