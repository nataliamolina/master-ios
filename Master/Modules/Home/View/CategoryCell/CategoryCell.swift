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

class CategoryCell: UITableViewCell, ConfigurableCellProtocol {
    // MARK: - UI References
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var categoryImageView: UIImageView!

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - Public Methods
    func setupWith(viewModel: Any?, indexPath: IndexPath?, delegate: Any?) {
        guard let viewModel = viewModel as? CategoryCellDataSource else {
            return
        }
        
        categoryImageView.kf.setImage(with: URL(string: viewModel.imageUrl))
    }
}
