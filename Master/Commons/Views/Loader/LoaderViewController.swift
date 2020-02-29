//
//  LoaderViewController.swift
//  Master
//
//  Created by Carlos Mejía on 29/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit
import Lottie

class LoaderViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var animationView: UIView!
    
    // MARK: - Properties
    private let animationTime: TimeInterval = 0.2
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showLoader()
    }
    
    // MARK: - Public Methods
    func dismissAnimated() {
        UIView.animate(withDuration: animationTime, animations: { [weak self] in
            self?.animationView.alpha = 0
            self?.view.backgroundColor = .clear
            self?.view.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.dismiss(animated: false, completion: nil)
        })
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .clear
        animationView.alpha = 0
        
        animationView.layer.cornerRadius = 15
        animationView.clipsToBounds = true
        
        let starAnimationView = AnimationView(name: AnimationType.loader.rawValue)
        starAnimationView.frame = animationView.bounds
        starAnimationView.play()
        starAnimationView.loopMode = .loop
        
        animationView.addSubview(starAnimationView)
    }
    
    private func showLoader() {
        UIView.animate(withDuration: animationTime) { [weak self] in
            self?.animationView.alpha = 1
            self?.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
            self?.view.layoutIfNeeded()
        }
    }
}
