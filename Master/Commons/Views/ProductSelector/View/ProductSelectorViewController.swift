//
//  ProductSelectorViewController.swift
//  Master
//
//  Created by Carlos Mejía on 19/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

protocol ProductSelectorDelegate: class {
    func productChanged(result: ProductSelectorResult)
    func doneButtonTapped(result: ProductSelectorResult)
}

class ProductSelectorViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var stepper: UIStepper!
    @IBOutlet private weak var productImageview: UIImageView!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var productDescLabel: UILabel!
    @IBOutlet private weak var productPriceLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    
    // MARK: - UI Actions
    @IBAction private func doneButtonAction(_ sender: Any) {
        delegate?.doneButtonTapped(result: getResult())

        if let navbarController = navigationController {
            navbarController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction private func stepperAction() {
        setCountValue()
    }
    
    // MARK: - Properties
    private weak var delegate: ProductSelectorDelegate?
    private let viewModel: ProductSelectorDataSource
    
    // MARK: - Life Cycle
    init(viewModel: ProductSelectorDataSource, delegate: ProductSelectorDelegate?) {
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init(nibName: String(describing: ProductSelectorViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        productNameLabel.text = viewModel.getName()
        productDescLabel.text = viewModel.getDescription()
        
        if viewModel.getTotalCount() == 0 {
            productPriceLabel.text = viewModel.getFormattedPrice()
            countLabel.text = 1.asString
        } else {
            stepper.value = Double(viewModel.getTotalCount())
            productPriceLabel.text = viewModel.getTotalPrice().toFormattedCurrency(withSymbol: true)
            countLabel.text = viewModel.getTotalCount().asString
        }
        
        productImageview.kf.setImage(with: URL(string: viewModel.getImageUrl()))
    }
    
    private func setCountValue() {
        countLabel.text = Int(stepper.value).asString
        
        let totalPrice = (viewModel.getPrice() * stepper.value)
        productPriceLabel.text = totalPrice.toFormattedCurrency(withSymbol: true)
        
        delegate?.productChanged(result: getResult())
    }
    
    private func getResult() -> ProductSelectorResult {
        return ProductSelectorResult(identifier: viewModel.getIdentifier(),
                                     total: Int(stepper.value),
                                     totalPrice: (viewModel.getPrice() * stepper.value))
    }
}
