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
    @IBOutlet private weak var animationView: UIView!
    
    // MARK: - Properties
    private var animationName: String = ""
    private var animationViewRef: AnimationView?
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        descLabel.text = nil
        
        animationViewRef?.pause()
        animationViewRef = nil
        animationView.subviews.forEach { $0.removeFromSuperview() }
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
        
        DispatchQueue.main.async { [weak self] in
            self?.setupAnimation()
        }
    }
    
    private func setupAnimation() {
        let animation = AnimationView(name: animationName)
        animation.play()
        animation.loopMode = .loop
        animation.translatesAutoresizingMaskIntoConstraints = false
        
        animationViewRef = animation
        animationView.addSubview(animation)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: animation,
                               attribute: .leading,
                               relatedBy: .equal,
                               toItem: animationView,
                               attribute: .leading,
                               multiplier: 1,
                               constant: 0),
            
            NSLayoutConstraint(item: animation,
                               attribute: .trailing,
                               relatedBy: .equal,
                               toItem: animationView,
                               attribute: .trailing,
                               multiplier: 1,
                               constant: 0),
            
            NSLayoutConstraint(item: animation,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: animationView,
                               attribute: .top,
                               multiplier: 1,
                               constant: 0),
            
            NSLayoutConstraint(item: animation,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: animationView,
                               attribute: .bottom,
                               multiplier: 1,
                               constant: 0)
        ])
        
        activityIndicator.stopAnimating()
    }
}
