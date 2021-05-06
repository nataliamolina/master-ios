//
//  ChatViewController.swift
//  Master
//
//  Created by Maria Paula on 21/04/21.
//  Copyright © 2021 Master. All rights reserved.
//

import UIKit
import AudioToolbox

class ChatViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var sendChatButton: UIButton!
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var chatTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatTextBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private var viewModel: ChatViewModel
    private var minTextViewHeight: CGFloat = 40
    private let maxTextViewHeight: CGFloat = 64
    private var keyboardHeight: CGFloat = 0
    private let generalTime: TimeInterval = 0.3
    
    // MARK: - UI Actions
    @IBAction func backAction() {
        if let navController = navigationController {
            navController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func sendChatButtonAction() {
        sendChatMessage()
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: String(describing: ChatViewController.self), bundle: nil)
        
        hero.isEnabled = true
        hero.modalAnimationType = .selectBy(presenting: .zoomSlide(direction: .left),
                                            dismissing: .zoomSlide(direction: .right))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        viewModel.stopListening()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        viewModel.delegate = self
        
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        
        sendChatButton.clipsToBounds = true
        sendChatButton.layer.cornerRadius = sendChatButton.frame.width / 2
        
        chatTextView.delegate = self
        chatTextView.text = nil
        chatTextView.layer.cornerRadius = 15
        
        let tablePadding: CGFloat = 30
        tableView.contentInset = UIEdgeInsets(top: tablePadding,
                                              left: 0,
                                              bottom: tablePadding,
                                              right: 0)
        
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        sendChatButton.isHidden = true
        tableView.separatorStyle = .none
        tableView.registerNib(ChatTableViewCell.self)
        
        userNameLabel.text = viewModel.name.isEmpty ? "Master" : viewModel.name
        if !viewModel.photoUrl.isEmpty {
            userImageView.kf.setImage(with: URL(string: viewModel.photoUrl))
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    private func sendChatMessage() {
        guard !chatTextView.text.isEmpty else {
            return
        }
        
        viewModel.sendChatMessage(chatTextView.text)
        chatTextView.text = nil
        chatTextViewHeightConstraint.constant = minTextViewHeight
    }

    /**
     Method to catch when the keyboard appears and modifify the ScrollView contentInset to improve the User experience using the form.
     - parameter notification: NotificationCenter object.
     */
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard
            let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            chatTextBottomConstraint.constant == 0 else {
                return
        }
        keyboardHeight = keyboardSize.height
        
        chatTextBottomConstraint.constant += keyboardSize.height
        
        UIView.animate(withDuration: generalTime, animations: { [weak self] in
            self?.view.layoutIfNeeded()
            }, completion: { [weak self] _ in
                self?.tableView.scrollToBottomRow()
        })
    }
    
    /**
     Method to catch when the keyboard hidde and modifify the ScrollView contentInset to improve the User experience using the form.
     */
    @objc private func keyboardWillHide() {
        chatTextBottomConstraint.constant = 0
        
        UIView.animate(withDuration: generalTime, animations: { [weak self] in
            self?.view.layoutIfNeeded()
            }, completion: { [weak self] _ in
                self?.tableView.scrollToBottomRow()
        })
    }
    
    /**
     Method to dismiss the keyboard if the user taps the screen.
     */
    @objc internal override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func requestLoaded() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func performLoading(isLoadig: Bool) {
        DispatchQueue.main.async { [weak self] in
            isLoadig ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
        }
    }
}

// MARK: - ChatViewModelDelegate
extension ChatViewController: ChatViewModelDelegate {    
    func chatMessagesLoaded() {
        tableView.reloadData()
        tableView.scrollToBottomRow()
    }
    
    func messageArrivedAt(indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        
        tableView.scrollToBottomRow()
    }
}

// MARK: - UITextViewDelegate
extension ChatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        guard !textView.text.comparable.isEmpty else {
            sendChatButton.isHidden = true
            return
        }
        
        sendChatButton.isHidden = false
        
        var height = ceil(textView.contentSize.height)
        
        if height < minTextViewHeight + 5 {
            height = minTextViewHeight
        }
        
        if height > maxTextViewHeight {
            height = maxTextViewHeight
        }
        
        if height != chatTextViewHeightConstraint.constant {
            chatTextViewHeightConstraint.constant = height
            chatTextView.setContentOffset(.zero, animated: false)
        }
    }
}

// MARK: - UITableViewDataSource
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataSourceCount = viewModel.chatDataSource.count
        
        return dataSourceCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.getWith(cellViewModel: viewModel.getViewModelAt(indexPath: indexPath),
                                 indexPath: indexPath,
                                 delegate: self)
    }
}
