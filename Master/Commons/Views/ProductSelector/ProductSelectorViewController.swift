//
//  ProductSelectorViewController.swift
//  Master
//
//  Created by Carlos Mejía on 19/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

protocol ProductSelectorDataSource {
    var imageUrl: String { get }
    var name: String { get }
    var description: String { get }
    var price: Double { get }
}

struct ProductSelectorItem: ProductSelectorDataSource {
    let imageUrl: String
    let name: String
    let description: String
    let price: Double
}

class ProductSelector {
    static func show(in viewController: UIViewController, item: ProductSelectorDataSource) {
        let vc = ProductSelectorViewController()
        vc.modalPresentationStyle = .formSheet
        
        viewController.navigationController?.present(vc, animated: true, completion: nil)
        
    }
    
    static func dismiss(in viewController: UIViewController) {
        
    }
}

class ProductSelectorViewController: UIViewController {
    @IBOutlet private weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        image.kf.setImage(with: URL(string: "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60"))
        // Do any additional setup after loading the view.
    }
}
