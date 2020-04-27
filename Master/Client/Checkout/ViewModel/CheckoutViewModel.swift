//
//  CheckoutViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 24/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import EasyBinding

enum CheckoutViewModelStatus {
    case undefined
    case error(error: String?)
    case fieldError(name: String)
    case orderSucceded
    case needsAuthentication
}

private enum Sections: Int {
    case header
    case buttons
    case list
}

class CheckoutViewModel {
    // MARK: - Properties
    private typealias Lang = CheckoutConstants.Lang
    private let provider: CheckoutProvider
    private let cart: [ProviderServiceCellViewModel]
    private let categoryId: Int
    private let service: CheckoutServiceProtocol
    private let storageService: AppStorageProtocol
    
    private var currentCity: String {
        let result: String? = storageService.get(key: CitySelectorViewModel.Keys.cityName.rawValue)
        
        return result ?? ""
    }
    
    private var currentCityId: Int {
        let result: Int? = storageService.get(key: CitySelectorViewModel.Keys.cityId.rawValue)
        
        return result ?? 1
    }
    
    let status = Var<CheckoutViewModelStatus>(.undefined)
    let isLoading = Var(false)
    let dataSource: Var<[CellViewModelProtocol]> = Var([])
    
    var customOptionSelected: RadioOption?
    
    // MARK: - Life Cycle
    init(provider: CheckoutProvider,
         cart: [ProviderServiceCellViewModel],
         categoryId: Int,
         service: CheckoutServiceProtocol = CheckoutService(connectionDependency: ConnectionManager()),
         storageService: AppStorageProtocol? = nil) {
        
        let defaultStorageService = AppStorage()
        
        self.provider = provider
        self.cart = cart
        self.categoryId = categoryId
        self.service = service
        self.storageService = storageService ?? defaultStorageService
    }
    
    // MARK: - Public Methods
    func createViewModels() {
        let headerCell = CheckoutHeaderCellViewModel(title: Lang.title,
                                                     value: getCartTotal().toFormattedCurrency(withSymbol: true))
        
        let providerCell = CheckoutProviderCellViewModel(name: provider.names,
                                                         description: provider.description,
                                                         photoUrl: provider.photoUrl)
        
        var fieldsCells: [CellViewModelProtocol] = [
            CheckoutFieldCellViewModel(title: Lang.address, value: "", image: .gps, type: .address),
            
            CheckoutFieldCellViewModel(title: Lang.dateAndHour, value: "", image: .calendar, type: .dates),
            
            CheckoutFieldCellViewModel(title: Lang.notes, value: "", image: .note, type: .notes),
            
            CheckoutFieldCellViewModel(title: Lang.city,
                                       value: currentCity,
                                       image: .building,
                                       type: .city,
                                       detailIconVisible: false),
            
            CheckoutFieldCellViewModel(title: Lang.products,
                                       value: Lang.cartTotal(getCartCountTotal()),
                                       image: .cart,
                                       bottomLineVisible: false,
                                       type: .cart,
                                       detailIconVisible: false)
        ]
        
        let buttonCell = ButtonCellViewModel(style: .green, title: Lang.reserve, value: nil)
        
        var viewModels: [CellViewModelProtocol] = [
            headerCell,
            providerCell,
            buttonCell
        ]
        
        if !getRadioOptions().isEmpty {
            fieldsCells.append(CheckoutRadioCellViewModel(options: getRadioOptions()))
        }
        
        viewModels.insert(contentsOf: fieldsCells, at: 2)
        
        /*
         Developer notes:
         You are probably wondering why we don't append directly to the data source these viewmodels right?
         - Well, by every time you append something new to the data source, the suscriber (in this case a UITableView) will be reloaded,
         so we should take care of the performance only with ONE append.
         */
        
        dataSource.value.append(contentsOf: viewModels)
    }
    
    func getViewModelAt(indexPath: IndexPath) -> CellViewModelProtocol? {
        return dataSource.value.safeContains(indexPath.row)
    }
    
    func getViewModelForCompleteAt(index: Int) -> CompleteTextViewModel {
        guard let textFieldViewModel = dataSource.value.safeContains(index) as? CheckoutFieldCellViewModel else {
            return .empty
        }
        
        return CompleteTextViewModel(title: textFieldViewModel.title,
                                     desc: "",
                                     placeholder: "",
                                     index: index,
                                     savedValue: textFieldViewModel.value)
    }
    
    func updateViewModelValueAt(index: Int, value: String) {
        guard let expectedField = dataSource.value.safeContains(index) as? CheckoutFieldCellViewModel else {
            return
        }
        
        expectedField.value = value
        
        dataSource.value[index] = expectedField
    }
    
    func updateDateViewModelValueAt(index: Int, date: Date) {
        guard let expectedField = dataSource.value.safeContains(index) as? CheckoutFieldCellViewModel else {
            return
        }
        
        expectedField.date = date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        
        expectedField.value = dateFormatter.string(from: date)
        
        dataSource.value[index] = expectedField
    }
    
    func performProviderReservation() {
        let fields = dataSource.value.filter { $0 is CheckoutFieldCellViewModel } as? [CheckoutFieldCellViewModel] ?? []
        let notes = fields.first(where: { $0.type == .notes })?.value
        
        guard let address = fields.first(where: { $0.type == .address })?.value, !address.isEmpty else {
            status.value = .fieldError(name: Lang.address)
            
            return
        }
        
        guard
            let dateField = fields.first(where: { $0.type == .dates }),
            let date = dateField.date,
            let json = dateField.dateAsJSON,
            !json.isEmpty else {
                
                status.value = .fieldError(name: Lang.dateAndHour)
                
                return
        }
        
        performPayment(address: address, notes: notes, jsonDate: json, date: date)
    }
    
    // MARK: - Private Methods
    private func getRadioOptions() -> [RadioOption] {
        guard categoryId == 1 else {
            return []
        }
        
        let selectedOption = RadioOption(name: "checkout.requirements.foodInHouse".localized, value: true)
        
        customOptionSelected = selectedOption
        
        return [
            RadioOption(name: "checkout.requirements.delivery".localized, value: false),
            selectedOption
        ]
    }
    
    private func getCartTotal() -> Double {
        return cart.map { $0.totalPrice }.reduce(0, +)
    }
    
    private func getCartCountTotal() -> Double {
        return Double(cart.map { $0.productCount }.reduce(0, +))
    }
    
    private func performPayment(address: String, notes: String?, jsonDate: String, date: Date) {
        let request = OrderRequest(providerId: provider.id,
                                   orderAddress: address,
                                   notes: notes ?? "",
                                   serviceCategoryId: categoryId,
                                   servicesIds: getCartIds(),
                                   orderDate: jsonDate,
                                   time: getFormattedTimeFrom(date: date),
                                   cityId: currentCityId,
                                   serviceRequirements: getRequirements())
        
        if !Session.shared.isLoggedIn {
            status.value = .needsAuthentication
            
            return
        }
        
        loadingState(true)
        
        service.performCheckout(request: request) { [weak self] (_, error: CMError?) in
            self?.loadingState(false)
            
            if let error = error {
                self?.status.value = .error(error: error.error)
                
                return
            }
            
            self?.status.value = .orderSucceded
        }
    }
    
    private func getCartIds() -> [Int] {
        var servicesIds = [Int]()
        
        cart.forEach { item in
            (1...item.productCount).forEach {_ in
                servicesIds.append(item.productId)
            }
        }
        
        return servicesIds
    }
    
    private func getFormattedTimeFrom(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        return dateFormatter.string(from: date)
    }
    
    private func loadingState(_ state: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading.value = state
        }
    }
    
    private func getRequirements() -> String {
        return customOptionSelected?.name ?? ""
    }
}
