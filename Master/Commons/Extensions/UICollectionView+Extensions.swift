//
//  UICollectionView+Extensions.swift
//  Master
//
//  Created by Carlos Mejía on 27/04/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

extension UICollectionView {
    func registerNib(_ type: UICollectionViewCell.Type) {
        register(UINib(nibName: String(describing: type), bundle: nil),
                 forCellWithReuseIdentifier: String(describing: type))
    }
    
    func getWith(cellViewModel: CellViewModelProtocol?,
                 indexPath: IndexPath,
                 delegate: Any?) -> UICollectionViewCell {
        
        let identifier = cellViewModel?.identifier ?? "😭 This is a crash, i'm sorry."
        
        let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        (cell as? ConfigurableCellProtocol)?.setupWith(viewModel: cellViewModel,
                                                       indexPath: indexPath,
                                                       delegate: delegate)
        
        return cell
    }
}
