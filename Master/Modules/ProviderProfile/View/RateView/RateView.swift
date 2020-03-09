//
//  RateView.swift
//  Master
//
//  Created by Carlos Mejía on 9/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class RateView: UIView {
    // MARK: - UI References
    @IBOutlet private weak var rateLabel: UILabel!
    
    // MARK: - Public Methods
    func setupWith(score: Double) {
        rateLabel.text = score.asString
    }
}
