//
//  ProviderOrderDetailViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 1/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit
import EasyBinding

enum ProviderOrderDetailViewModelStatus {
    case undefined
    case error(error: String?)
    case stateUpdated
}

class ProviderOrderDetailViewModel {
    // MARK: - Properties
    private var cart = [OrderProviderService]()
    private let service: ProviderOrderDetailServiceProtocol
    private let orderId: Int
    private var currentState: OrderStateType = .unknown
    private typealias CheckoutLang = CheckoutConstants.Lang
    
    let formattedTotal = Var("$0")
    let status = Var<ProviderOrderDetailViewModelStatus>(.undefined)
    let isLoading = Var(false)
    let dataSource = Var<[CellViewModelProtocol]>([])
    
    // MARK: - Life Cycle
    init(orderId: Int, service: ProviderOrderDetailServiceProtocol? = nil) {
        let defaultService = ProviderOrderDetailService(connectionDependency: ConnectionManager())
        
        self.orderId = orderId
        self.service = service ?? defaultService
    }
    
    // MARK: - Public Methods
    
    func fetchDetail() {
        isLoading.value = true
        
        service.fetchOrderDetailBy(id: orderId) { [weak self] (response: Order?, error: CMError?) in
            self?.isLoading.value = false
            
            guard let model = response, error == nil else {
                self?.status.value = .error(error: error?.localizedDescription)
                
                return
            }
            
            self?.cart = model.orderProviderServices ?? []
            self?.responseToViewModels(model: model)
            self?.fetchOrderServices()
        }
    }
    
    func rejectOrder() {
        performOrderState(.rejected)
    }
    
    func updateOrderState() {
        switch currentState {
        case .paymentDone:
            performOrderState(.inProgress)
            
        case .inProgress:
            performOrderState(.finished)
            
        case .pending:
            performOrderState(.pendingForPayment)
            
        default:
            return
        }
    }
    
    func getViewModelAt(indexPath: IndexPath) -> CellViewModelProtocol? {
        return dataSource.value.safeContains(indexPath.row)
    }
    
    func getPaymentViewModel() -> PaymentViewModel {
        return PaymentViewModel(orderId: orderId,
                                formattedTotal: formattedTotal.value,
                                userId: Session.shared.profile.id,
                                userEmail: Session.shared.profile.email)
    }
    
    func getRateViewModel() -> RateViewModel {
        return RateViewModel(orderId: orderId)
    }
    
    // MARK: - Private Methods
    
    private func performOrderState(_ state: OrderStateType) {
        isLoading.value = true
        
        service.updateOrderState(orderId: orderId, stateId: state.id) { [weak self] (response: OrderState?, error: CMError?) in
            
            self?.isLoading.value = false
            
            guard let newState = response, error == nil else {
                self?.status.value = .error(error: error?.localizedDescription)
                
                return
            }
            
            self?.currentState = newState.type
            self?.status.value = .stateUpdated
        }
    }
    
    private func responseToViewModels(model: Order) {
        dataSource.value.removeAll()

        self.currentState = model.orderState.type
        self.formattedTotal.value = model.grossTotal.toFormattedCurrency()
        
        let headerViewModel = OrderDetailHeaderCellViewModel(orderId: model.id,
                                                             status: model.orderState.type,
                                                             providerName: model.provider.user.names,
                                                             orderDate: Utils.jsonToFormattedDate(model.orderDate),
                                                             isProvider: true)
        
        // FIXME: Strings
        let helpButtonViewModel = ButtonCellViewModel(style: .redBorder, title: "¿Necesitas Ayuda?", value: nil)
        
        let fieldsCells = [
            CheckoutFieldCellViewModel(title: CheckoutLang.address,
                                       value: model.orderAddress,
                                       image: .gps,
                                       type: .address,
                                       detailIconVisible: false),
            
            CheckoutFieldCellViewModel(title: CheckoutLang.dateAndHour,
                                       value: Utils.jsonToFormattedDate(model.orderDate),
                                       image: .calendar,
                                       type: .dates,
                                       detailIconVisible: false),
            
            CheckoutFieldCellViewModel(title: CheckoutLang.notes, 
                                       value: model.notes.isEmpty ? "-" : model.notes,
                                       image: .note,
                                       type: .notes,
                                       detailIconVisible: false),
            
            CheckoutFieldCellViewModel(title: CheckoutLang.city,
                                       value: model.city?.name ?? "",
                                       image: .building,
                                       type: .city,
                                       detailIconVisible: false),
            
            CheckoutFieldCellViewModel(title: CheckoutLang.conditions,
                                       value: model.serviceRequirements ?? "",
                                       image: .checkList,
                                       bottomLineVisible: false,
                                       type: .city,
                                       detailIconVisible: false)
        ]
        
        dataSource.value.append(headerViewModel)
        dataSource.value.append(helpButtonViewModel)
        dataSource.value.append(contentsOf: fieldsCells)
        
    }
    
    private func getCartCountTotal() -> Double {
        return Double(cart.map { $0.getId() }.reduce(0, +))
    }
    
    private func fetchOrderServices() {
        service.fetchOrderServices(id: orderId) { [weak self] (response: [OrderProviderService], error: CMError?) in
            
            guard error == nil else {
                self?.status.value = .error(error: error?.localizedDescription)
                
                return
            }
            
            self?.orderServicesToViewModels(models: response)
        }
    }
    
    private func orderServicesToViewModels(models: [OrderProviderService]) {
        let products = models.map {
            ProviderServiceCellViewModel(productImageUrl: $0.getPhotoUrl() ?? "",
                                         productName: $0.getName(),
                                         productDesc: $0.getDescription(),
                                         productPrice: $0.getPrice(),
                                         productCount: 0,
                                         productId: $0.getId())
        }
        
        dataSource.value.append(contentsOf: getGroupedServices(models: products))
    }
    
    private func getGroupedServices(models: [ProviderServiceCellViewModel]) -> [ProviderServiceCellViewModel] {
        var result = [ProviderServiceCellViewModel]()
        
        for index in models.indices {
            if let indexFound = result.firstIndex(where: { $0 == models[index] }) {
                result[indexFound].productCount += 1
            } else {
                result.append(models[index])
            }
        }
        
        return result
    }
}
