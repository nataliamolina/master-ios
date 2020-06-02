//
//  ProviderWelcomeViewController.swift
//  Master
//
//  Created by Carlos Mejía on 3/05/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class ProviderWelcomeViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var prevPageButton: UIButton!
    @IBOutlet private weak var nextPageButton: UIButton!
    
    // MARK: - UI Actions
    @IBAction private func skipButtonAction() {
        saveWatchedState()
    }

    @IBAction private func prevPageButtonAction() {
        collectionView.scrollToItem(at: IndexPath(row: currentIndex - 1, section: 0), at: .left, animated: true)
    }
    
    @IBAction private func nextPageButtonAction() {
        let nextIndex = currentIndex + 1
        
        if viewModel.dataSource.indices.contains(nextIndex) {
            collectionView.scrollToItem(at: IndexPath(row: currentIndex + 1, section: 0),
                                        at: .right,
                                        animated: true)
        } else {
            saveWatchedState()
        }
    }
    
    // MARK: - Properties
    private let router: ProviderRouter
    private let viewModel: ProviderWelcomeViewModel
    private let storeService: AppStorageProtocol
    
    private var currentIndex: Int {
        return collectionView.indexPathsForVisibleItems.first?.row ?? 0
    }
    
    // MARK: - Life Cycle
    init(viewModel: ProviderWelcomeViewModel,
         router: ProviderRouter,
         storeService: AppStorageProtocol = AppStorage()) {
        
        self.storeService = storeService
        self.viewModel = viewModel
        self.router = router
        
        super.init(nibName: String(describing: ProviderWelcomeViewController.self), bundle: nil)
        
        modalPresentationStyle = .fullScreen
        hero.isEnabled = true
        hero.modalAnimationType = .selectBy(presenting: .zoom, dismissing: .zoomOut)
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
        prevPageButton.isHidden = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNib(BasicWelcomeCell.self)
    }
    
    private func saveWatchedState() {
        storeService.save(value: false, key: ProviderMainViewModel.Keys.providerWelcome.rawValue)
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension ProviderWelcomeViewController: UICollectionViewDataSource {
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
extension ProviderWelcomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.bounds.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCurrentPage(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateCurrentPage(scrollView)
    }
    
    private func updateCurrentPage(_ scrollView: UIScrollView) {
        let newPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        pageControl.currentPage = newPage
        
        if let visibleCell = collectionView.cellForItem(at: IndexPath(row: newPage, section: 0)) as? BasicWelcomeCell {
            visibleCell.setupAnimation()
        }

        prevPageButton.isHidden = newPage <= 0
    }
}
