//
//  ProviderMainViewController.swift
//  Master
//
//  Created by Carlos Mejía on 12/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class ProviderMainViewController: UIViewController {
    // MARK: - UI References
    @IBAction private func closeButtonAction(_ sender: Any) {
        navigationController?.hero.modalAnimationType =  .zoomOut
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
