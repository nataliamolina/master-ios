//
//  HomeViewController.swift
//  Master
//
//  Created by Luis Carlos Mejia Garcia on 12/26/19.
//  Copyright © 2019 Master. All rights reserved.
//

import UIKit
import Hero

class HomeViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var pendingView: UIView!
    @IBOutlet private weak var pendingLabel: UILabel!
    
    // MARK: - Properties
    private var pushNotificationsRouter: PushNotificationsRouter?
    private let viewModel = HomeViewModel()
    private let router: RouterBase<HomeRouterTransitions>
    private let heroTransition = HeroTransition()
    
    // MARK: - Life Cycle
    
    init(router: RouterBase<HomeRouterTransitions>) {
        self.router = router
        
        super.init(nibName: String(describing: HomeViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupNavigationGesture()
        checkVersion()
        viewModel.fetchOrders()
        
        PushNotifications.shared.hasPendingNotification.listen(triggerInitialValue: true) { [weak self] hasPendingNotification in
            if hasPendingNotification {
                self?.checkPendingNotification()
            }
        }
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        // FIXME
        title = "Servicios"
        
        setupBindings()
        
        pendingView.isHidden = true
        pendingView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                action: #selector(pendingViewTapped)))
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.registerNib(CategoryCell.self)
        
        setupMenuIcon()
        setupLogoIcon()
        
        viewModel.fetchServices()
    }
    
    private func checkPendingNotification() {
        guard let pendingNotification = PushNotifications.shared.pendingNotification else {
            return
        }
        
        handlePushNotificationIfNeeded(pendingNotification: pendingNotification)
    }
    
    private func setupBindings() {
        viewModel.hasPendingOrders.listen { hasPendingOrders in
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.pendingView.isHidden = hasPendingOrders ? false : true
            }
        }
        
        viewModel.dataSource.bindTo(tableView, to: .dataSource)
        viewModel.totalOrders.bindTo(pendingLabel, to: .text)
        
        viewModel.isLoading.listen { isLoading in
            isLoading ? Loader.show() : Loader.dismiss()
        }
    }
    
    private func handlePushNotificationIfNeeded(pendingNotification: PushNotification) {
        guard
            let pendingNotification = PushNotifications.shared.pendingNotification,
            let navController = navigationController as? MNavigationController else {
                return
        }
        
        showSuccess(message: pendingNotification.message)
        pushNotificationsRouter = PushNotificationsRouter(notification: pendingNotification)
        pushNotificationsRouter?.ordersRouter = OrdersRouter(navigationController: navController)
        pushNotificationsRouter?.providerRouter = ProviderRouter(navigationController: navController)
        pushNotificationsRouter?.navigateToPushNotification()
    }
    
    private func setupMenuIcon() {
        let leftImage = UIBarButtonItem(image: .menu, style: .plain, target: self, action: #selector(menuButtonTapped))
        leftImage.tintColor = .black
        navigationItem.leftBarButtonItem = leftImage
    }
    
    private func setupLogoIcon() {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .greenLogoIcon
        
        navigationItem.titleView = imageView
    }
    
    private func checkVersion() {
        let featureFlags = RemoteConfigMaster()
        let flag = "VERSION_APP"
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        if featureFlags.isAvaliable(module: flag) != version &&
            !featureFlags.isAvaliable(module: flag).isEmpty {
            confirmServiceUpdate(onConfirmed: {})
            return
        }
    }
    
    private func confirmServiceUpdate(onConfirmed: @escaping () -> Void) {
        let dialog = UIAlertController(title: "Actualización",
                                       message: "Actualmnete hay una actualización disponibles, ingresa a tu App Store y actualiza.",
                                       preferredStyle: .alert)
        
        dialog.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: nil))
        
        dialog.addAction(UIAlertAction(title: "Aceptar", style: .destructive, handler: { _ in
            onConfirmed()
        }))
        
        present(dialog, animated: true, completion: nil)
    }
    
    @objc private func menuButtonTapped() {
        router.transition(to: .menu)
    }
    
    @objc private func pendingViewTapped() {
        router.transition(to: .orders)
    }
}

// MARK: - CategoryCellDelegate
extension HomeViewController: CategoryCellDelegate {
    func cellTapped(_ cell: CategoryCell) {
        guard
            let indexPath = tableView.indexPath(for: cell),
            let cellViewModel = viewModel.getViewModelAt(indexPath: indexPath) as? CategoryCellViewModel else {
                return
        }
        
        router.transition(to: .providerList(id: cellViewModel.serviceId,
                                            serviceImageUrl: cellViewModel.imageUrl))
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dataSource.value.count
    }
    
   /* func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sectionTitles.safeContains(section)
    }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.value.safeContains(section)?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.getWith(cellViewModel: viewModel.getViewModelAt(indexPath: indexPath),
                                 indexPath: indexPath,
                                 delegate: self)
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as? UITableViewHeaderFooterView)?.contentView.backgroundColor = UIColor.white
        (view as? UITableViewHeaderFooterView)?.textLabel?.textColor = UIColor.black
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension HomeViewController: UIGestureRecognizerDelegate {
    private func setupNavigationGesture() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return (otherGestureRecognizer is UIScreenEdgePanGestureRecognizer)
    }
}
