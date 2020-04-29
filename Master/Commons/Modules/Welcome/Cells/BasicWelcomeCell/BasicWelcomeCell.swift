//
//  BasicWelcomeCell.swift
//  Master
//
//  Created by Carlos Mejía on 27/04/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit
import Lottie

protocol BasicWelcomeCellDataSource {
    var title: String { get }
    var desc: String { get }
    var animName: AnimationType { get }
}

class BasicWelcomeCell: UICollectionViewCell, ConfigurableCellProtocol {
    // MARK: - UI References
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descLabel: UILabel!
    @IBOutlet private weak var animationView: AnimationView!

    // MARK: - Properties
    private var animationName: String = ""
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
 
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        descLabel.text = nil
        
        animationView.stop()
    }

    // MARK: - Public Methods
    
    func setupWith(viewModel: Any?, indexPath: IndexPath?, delegate: Any?) {
        guard let viewModel = viewModel as? BasicWelcomeCellDataSource else {
            return
        }
        
        activityIndicator.startAnimating()
        
        titleLabel.text = viewModel.title
        descLabel.text = viewModel.desc
        
        animationName = viewModel.animName.rawValue
        
        if indexPath?.row == 0 {
            setupAnimation()
        }
    }
    
    func setupAnimation() {
        animationView.animation = Animation.named(animationName)
        animationView.play()
        animationView.loopMode = .loop
        
        activityIndicator.stopAnimating()
    }
}
