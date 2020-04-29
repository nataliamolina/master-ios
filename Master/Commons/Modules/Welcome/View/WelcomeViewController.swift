//
//  WelcomeViewController.swift
//  Master
//
//  Created by Carlos Mejía on 26/04/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class WelcomeViewModel {
    // MARK: - Properties
    private(set) var dataSource = [CellViewModelProtocol]()
    private let storageService: AppStorageProtocol
    
    // MARK: - Life Cycle
    init(storageService: AppStorageProtocol = AppStorage()) {
        self.storageService = storageService
        
        setupDataSource()
    }
    
    // MARK: - Private Methods
    private func setupDataSource() {
        dataSource.append(contentsOf: [
            BasicWelcomeCellViewModel(title: "welcome.screen1.title".localized,
                                      desc: "welcome.screen1.desc".localized,
                                      animName: .firstWelcome),
            
            BasicWelcomeCellViewModel(title: "welcome.screen2.title".localized,
                                      desc: "welcome.screen2.desc".localized,
                                      animName: .secondWelcome),
            
            BasicWelcomeCellViewModel(title: "welcome.screen3.title".localized,
                                      desc: "welcome.screen3.desc".localized,
                                      animName: .thirdWelcome)
        ])
    }
}

class WelcomeViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    
    // MARK: - UI Actions
    @IBAction private func skipButtonAction() {
        
    }
    
    // MARK: - Properties
    private let router: MainRouter
    private let viewModel: WelcomeViewModel

    // MARK: - Life Cycle
    init(viewModel: WelcomeViewModel, router: MainRouter) {
        self.viewModel = viewModel
        self.router = router
        
        super.init(nibName: String(describing: WelcomeViewController.self), bundle: nil)
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
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNib(BasicWelcomeCell.self)
    }
}

// MARK: - UICollectionViewDataSource
extension WelcomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = viewModel.dataSource.count
        
        return viewModel.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return collectionView.getWith(cellViewModel: viewModel.dataSource.safeContains(indexPath.row),
                                      indexPath: indexPath,
                                      delegate: self)
    }
}

// MARK: - UICollectionViewDataSource
extension WelcomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.bounds.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let cell = collectionView.visibleCells.first as? BasicWelcomeCell
        cell?.setupAnimation()
        
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let cell = collectionView.visibleCells.first as? BasicWelcomeCell
        cell?.setupAnimation()
        
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}
