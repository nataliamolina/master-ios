//
//  ChatViewModel.swift
//  Master
//
//  Created by Maria Paula on 2/05/21.
//  Copyright © 2021 Master. All rights reserved.
//

import Foundation
import UIKit

protocol ChatViewModelDelegate: class {
    func messageArrivedAt(indexPath: IndexPath)
    func chatMessagesLoaded()
}

enum ChatClientResultType {
    case success(messages: [ChatMessage], chatId: String)
    case error(error: Error?)
}

protocol ChatClientDelegate: class {
    func newMessageArrived(result: ChatClientResultType)
}

class ChatViewModel {
    // MARK: - Properties
    weak var delegate: ChatViewModelDelegate?
    private var chatId: String
    private var userId: String
    private var sentTo: PushNotificationType
    private var sentToToken: String
    private var pushNotificationService: PushNotificationServiceProtocol
    var photoUrl: String
    var name: String
    
    // MARK: - Manager Properties
    private var chatManager: ChatClient
    
    // MARK: - DataSource Properties
    private(set) var chatDataSource = [CellViewModelProtocol]()
    
    // MARK: - Life Cycle
    
    init(chatId: String,
         userId: String,
         photoUrl: String,
         name: String,
         sentToToken: String,
         sentTo: PushNotificationType,
         chatManager: ChatClient = ChatClient(),
         pushNotificationService: PushNotificationServiceProtocol = PushNotificationService()) {
        
        self.userId = userId
        self.chatId = chatId
        self.name = name
        self.photoUrl = photoUrl
        self.chatManager = chatManager
        self.sentToToken = sentToToken
        self.sentTo = sentTo
        self.pushNotificationService = pushNotificationService
        self.chatManager.delegate = self
        
        fetchData()
    }
    
    // MARK: - Public Methods
    
    func fetchData() {
        chatManager.fetchAllMessages(chatId: chatId)
    }
    
    func stopListening() {
        chatManager.stopListeningUpdates()
    }

    func sendChatMessage(_ message: String) {
        chatManager.sendMessage(message, userId: userId, chatId: chatId)
        pushNotificationService.send(to: sentToToken,
                                     title: "title.push".localized + chatId,
                                     message: message,
                                     actionId: chatId,
                                     actionType: sentTo)
    }
    
    func getViewModelAt(indexPath: IndexPath) -> CellViewModelProtocol? {
        return chatDataSource[indexPath.row]
    }
    
    private func addNewMessageViewModel() {
        guard let newMessage = chatManager.messages.last else {
            return
        }
        
        var alignText: NSTextAlignment = .left
        
        if newMessage.authorId == userId {
            alignText = .right
        }
       
        let configViewModel = ChatTableViewCellViewModel(messageId: newMessage.messageId,
                                                         authorId: newMessage.authorId,
                                                         chatMessage: newMessage.message,
                                                         createdAt: newMessage.createdAt.components(separatedBy: " ").first ?? "",
                                                         alignText: alignText)
        
        chatDataSource.append(configViewModel)
        delegate?.messageArrivedAt(indexPath: IndexPath(row: chatDataSource.count - 1, section: 0))
    }
}
// MARK: - ChatClientDelegate
extension ChatViewModel: ChatClientDelegate {
    func newMessageArrived(result: ChatClientResultType) {
        switch result {
        case .success:
            addNewMessageViewModel()
        case .error:
            break
        }
    }
}
