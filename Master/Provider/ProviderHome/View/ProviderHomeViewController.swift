//
//  ProviderHomeViewController.swift
//  Master
//
//  Created by Carlos Mejía on 12/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit
import Kingfisher

class ProviderHomeViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - UI Actions
    @IBAction private func addServiceButtonAction() {
        router.transition(to: .addService(viewModel: viewModel.getAddServiceViewModel(),
                                          delegate: self))
    }
    
    // MARK: - Properties
    private let router: RouterBase<ProviderRouterTransitions>
    private let viewModel: ProviderHomeViewModel
    
    // MARK: - Life Cycle
    
    init(viewModel: ProviderHomeViewModel, router: RouterBase<ProviderRouterTransitions>) {
        self.viewModel = viewModel
        self.router = router
        
        super.init(nibName: String(describing: ProviderHomeViewController.self), bundle: nil)
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
        disableTitle()
        
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.delegate = self
        
        tableView.registerNib(ProviderServiceCell.self)
        tableView.registerNib(ProviderProfileCell.self)
        tableView.registerNib(SelectorCell.self)
        tableView.registerNib(ProviderOrderCell.self)
        tableView.registerNib(ProviderInfoCell.self)
        tableView.registerNib(ProviderProfileTitleCell.self)
        
        setupBindings()
        
        viewModel.fetchData()
        
        checkPendingDetailFromPush()
        
        ProviderHomeViewModel.homeAlreadyOpened = true
    }
    
    private func checkPendingDetailFromPush() {
        if let currentRouter = (router as? ProviderRouter),
            let pendingViewModel = currentRouter.pendingDetailFromPush {
            
            router.transition(to: .orderDetail(viewModel: pendingViewModel))
            currentRouter.pendingDetailFromPush = nil
        }
    }
    
    private func setupBindings() {
        viewModel.dataSource.bindTo(tableView, to: .dataSource)
        
        viewModel.isLoading.listen { isLoading in
            isLoading ? Loader.show() : Loader.dismiss()
        }
        
        viewModel.status.listen { [weak self] status in
            switch status {
            case .error(let error):
                self?.showError(message: error)
                
            case .providerProfileLoaded(let name):
                self?.title = name
                
            case .undefined:
                return
            }
        }
    }
}

// MARK: - SelectorCellDelegate
extension ProviderHomeViewController: SelectorCellDelegate {
    func buttonTapped(at index: Int, title: String, button: MButton) {
        viewModel.toggleCommentsSection(with: index)
    }
}

// MARK: - ProviderPhotoViewControllerDelegate
extension ProviderHomeViewController: ProviderPhotoViewControllerDelegate {
    func imageEdited(provider: ProviderProfile?) {
        if let image = provider?.photoUrl {
          ImageCache.default.removeImage(forKey: image)
        }
       viewModel.updateProvider(provider: provider)
    }
}

// MARK: - ProviderEditViewControllerDelegate
extension ProviderHomeViewController: ProviderEditViewControllerDelegate {
    func infoEdited(provider: ProviderProfile?) {
        viewModel.updateProvider(provider: provider)
    }
}

// MARK: - UITableViewDataSource
extension ProviderHomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dataSource.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.value.safeContains(section)?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.getWith(cellViewModel: viewModel.getViewModelAt(indexPath: indexPath),
                                 indexPath: indexPath,
                                 delegate: self)
    }
}

// MARK: - AddProviderServiceDelegate
extension ProviderHomeViewController: AddProviderServiceDelegate {
    func serviceEdited(service: ProviderService) {
        viewModel.fetchServices()
    }
    
    func serviceAdded() {
        viewModel.fetchServices()
    }
}

// MARK: - AddProviderServiceDelegate
extension ProviderHomeViewController: ProviderOrderCellDelegate {
    func cellTapped(_ cell: ProviderOrderCell, viewModel: ProviderOrderCellDataSource) {
        router.transition(to: .orderDetail(viewModel: ProviderOrderDetailViewModel(orderId: viewModel.id.asInt)))
    }
}

// MARK: - ProviderInfoEditDelegate
extension ProviderHomeViewController: ProviderInfoEditDelegate {
    func serviceEdited(info: [ProviderInfoServiceModel]) {
        viewModel.updateInfo(models: info)
    }
}

// MARK: - ProviderProfileCellDelegate
extension ProviderHomeViewController: ProviderProfileCellDelegate {
    func editPhoto() {
        router.transition(to: .uploadPhoto(delegate: self))
    }
    
    func editDesc() {
        router.transition(to: .editProvider(delegate: self))
    }
}

// MARK: - ProviderProfileTitleCellDelegate
extension ProviderHomeViewController: ProviderProfileTitleCellDelegate {
    func addInfoCellTapped(_ cell: ProviderProfileTitleCell, viewModel: ProviderProfileTitleViewModel) {
        if viewModel.providerInfoType == .study {
            router.transition(to: .providerStudies(viewModel: self.viewModel.getProviderInfoViewModel(), delegate: self))
            return
        }
        router.transition(to: .providerExperience(viewModel: self.viewModel.getProviderInfoViewModel(), delegate: self))
    }
}

// MARK: - UITableViewDelegate
extension ProviderHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        guard viewModel.isEditedCell(indexPath: indexPath) else { return [] }
        
        let blockAction = UITableViewRowAction(style: .normal,
                                               title: "provider.edit".localized) { [weak self] (_, indexPath) in
                                                self?.editInfo(indexPath: indexPath)
        }
        
        blockAction.backgroundColor = UIColor.Master.green
        
        let deleteAction = UITableViewRowAction(style: .normal,
                                                title: "provider.remove".localized) { [weak self] (_, indexPath) in
                                                    self?.deleInfo(indexPath: indexPath)
        }
        
        deleteAction.backgroundColor = UIColor.Master.red
        
        return [deleteAction, blockAction]
    }
    
    func editInfo(indexPath: IndexPath) {
        if let dates = viewModel.getAddServiceViewModel(indexPath: indexPath) {
           router.transition(to: .addService(viewModel: dates, delegate: self))
        }
        
        guard let dates = viewModel.getProviderInfoCellDataSource(indexPath: indexPath) else { return }
        
        if dates.providerInfoType == .study {
            router.transition(to: .providerStudies(viewModel: viewModel.getProviderInfoViewModel(infoCell: dates), delegate: self))
            return
        }
        router.transition(to: .providerExperience(viewModel: viewModel.getProviderInfoViewModel(infoCell: dates), delegate: self))
    }
    
    func deleInfo(indexPath: IndexPath) {
        if let id = viewModel.getProviderServiceModelId(indexPath: indexPath) {
            confirmInfoDelete(title: "serviceDetail.dialog.title".localized,
                              message: "serviceDetail.dialog.message".localized) { [weak self] in
                self?.viewModel.deleteService(providerId: id)
            }
        }
        
        guard let dates = viewModel.getProviderInfoCellDataSource(indexPath: indexPath) else { return }
        
        var title = "providerExperience.dialog.title".localized
        var message = "providerExperience.dialog.message".localized
        
        if dates.providerInfoType == .study {
             title = "providerStudies.dialog.title".localized
             message = "providerStudies.dialog.message".localized
        }
        
        confirmInfoDelete(title: title,
        message: message) { [weak self] in
            self?.viewModel.deleteInfo(id: dates.id)
        }
    }
    
    private func confirmInfoDelete(title: String, message: String, onConfirmed: @escaping () -> Void) {
        let dialog = UIAlertController(title: title,
                                       message: message,
                                       preferredStyle: .alert)
        
        dialog.addAction(UIAlertAction(title: "providerInfo.cancel".localized, style: .default, handler: nil))
        
        dialog.addAction(UIAlertAction(title: "providerInfo.acept".localized, style: .destructive, handler: { _ in
            onConfirmed()
        }))
        
        present(dialog, animated: true, completion: nil)
    }
}
