//
//  ListSelectorViewController.swift
//  Master
//
//  Created by Carlos Mejía on 14/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

protocol ListSelectorViewControllerDelegate: class {
    func optionSelectedAt(index: Int, option: ListItemProtocol, uniqueIdentifier: String?)
}

class ListSelectorViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var descLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Properties
    private weak var delegate: ListSelectorViewControllerDelegate?
    private var viewModel: ListSelectorViewModel

    // MARK: - Life Cycle
    init(viewModel: ListSelectorViewModel, delegate: ListSelectorViewControllerDelegate?) {
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init(nibName: String(describing: ListSelectorViewController.self), bundle: nil)
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
        titleLabel.text = viewModel.title ?? titleLabel.text
        descLabel.text = viewModel.desc ?? descLabel.text
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource
extension ListSelectorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.cellIdentifier, for: indexPath)
        cell.textLabel?.text = viewModel.dataSource.safeContains(indexPath.row)?.value
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ListSelectorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = viewModel.dataSource.safeContains(indexPath.row) else {
            return
        }
        
        navigationController?.popViewController(animated: true)
        
        delegate?.optionSelectedAt(index: indexPath.row, option: item, uniqueIdentifier: viewModel.identifier)
    }
}
