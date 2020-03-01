//
//  LoaderView.swift
//  Master
//
//  Created by Carlos Mejía on 29/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit
import Lottie

class LoaderView: UIView {
    // MARK: - UI References
    @IBOutlet private weak var animationView: UIView!
    
    // MARK: - Properties
    private let animationTime: TimeInterval = 0.2
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - Public Methods
    func dismissAnimated(onComplete: (() -> Void)?) {
        UIView.animate(withDuration: animationTime, animations: { [weak self] in
            self?.animationView.alpha = 0
            self?.backgroundColor = .clear
            }, completion: { _ in
                onComplete?()
        })
    }
    
    func showLoader() {
        UIView.animate(withDuration: animationTime) { [weak self] in
            self?.animationView.alpha = 1
            self?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        }
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .clear
        animationView.alpha = 0
        
        animationView.layer.cornerRadius = 15
        animationView.clipsToBounds = true
        
        let starAnimationView = AnimationView(name: AnimationType.loader.rawValue)
        starAnimationView.frame = animationView.bounds
        starAnimationView.play()
        starAnimationView.loopMode = .loop
        
        animationView.addSubview(starAnimationView)
    }
}
