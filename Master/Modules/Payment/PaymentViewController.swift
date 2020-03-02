//
//  PaymentViewController.swift
//  Master
//
//  Created by Carlos Mejía on 1/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit
import PaymentezSDK

class PaymentViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var paymentezView: UIView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        _ = addPaymentezWidget(toView: paymentezView,
                               delegate: nil,
                               uid: "testing uuid",
                               email: "testing email")
    }
}
