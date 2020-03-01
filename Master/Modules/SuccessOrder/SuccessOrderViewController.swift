//
//  SuccessOrderViewController.swift
//  Master
//
//  Created by Carlos Mejía on 29/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit
import Lottie

class SuccessOrderViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet weak var animationView: UIView!
    
    // MARK: - UI Actions
    @IBAction func continueButtonAction() {
        router.transition(to: .ordersList)
    }
    
    // MARK: - Properties
    private let router: CheckoutRouter
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Life Cycle
    
    init(router: CheckoutRouter) {
        self.router = router
        
        super.init(nibName: String(describing: SuccessOrderViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        let starAnimationView = AnimationView(name: AnimationType.success.rawValue)
        starAnimationView.frame = animationView.bounds
        starAnimationView.play()
        starAnimationView.loopMode = .playOnce
        
        animationView.addSubview(starAnimationView)
    }
}
