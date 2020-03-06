//
//  StatusHelper.swift
//  Master
//
//  Created by Carlos Mejía on 1/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class StatusHelper {
    func setupButton(_ button: MButton, state: OrderStateType) {
        button.style = buttonStyles[state]
    }
    
    func setupLabel(_ label: UILabel, state: OrderStateType, withBackground: Bool = false) {
        label.backgroundColor = withBackground ? styles[state] : label.backgroundColor
        label.text = stateName[state]
        label.textColor = .white
    }
    
    func setupView(_ view: UIView, state: OrderStateType) {
        view.backgroundColor = styles[state]
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
    }
    
    private let styles: [OrderStateType: UIColor] = [
        .accepted: UIColor.Master.green,
        .finished: UIColor.Master.green,
        .inProgress: UIColor.Master.yellow,
        .rejected: UIColor.Master.red,
        .pending: UIColor.Master.yellow,
        .pendingForPayment: UIColor.Master.yellow,
        .paymentDone: UIColor.Master.green
    ]
    
    private let buttonStyles: [OrderStateType: MButtonType] = [
        .accepted: .green,
        .finished: .green,
        .inProgress: .yellow,
        .rejected: .redBorder,
        .pending: .yellow,
        .pendingForPayment: .yellow,
        .paymentDone: .green
    ]
    
    private let stateName: [OrderStateType: String] = [
        .accepted: "general.state.acepted".localized,
        .finished: "general.state.finished".localized,
        .inProgress: "general.state.inProgress".localized,
        .rejected: "general.state.rejected".localized,
        .pending: "general.state.pending".localized,
        .pendingForPayment: "general.state.paymentPending".localized,
        .paymentDone: "general.state.paymentDone".localized
    ]
}
