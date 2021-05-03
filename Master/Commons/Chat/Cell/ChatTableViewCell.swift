//
//  ChatTableViewCell.swift
//  Master
//
//  Created by Maria Paula on 21/04/21.
//  Copyright © 2021 Master. All rights reserved.
//
import UIKit

class ChatTableViewCell: UITableViewCell, ConfigurableCellProtocol {
    // MARK: - Properties
    private var indexPath: IndexPath?
    private var constraintsList: [NSLayoutConstraint]?
    private var marginTopChatTextLabel: CGFloat = 6
    private typealias Constant = ChatTableViewCellConstant
    private var dataSource: ChatTableViewCellViewModel?
    
    // MARK: - chat views
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constant.textColor
        label.font = Constant.dateLabelFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chatTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bubble: UIView = {
        let bubble = UIView()
        bubble.clipsToBounds = true
        bubble.layer.cornerRadius = 5
        bubble.translatesAutoresizingMaskIntoConstraints = false
        return bubble
    }()
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        setupUI()
    }
    
    // MARK: - Public Methods
    
    func setupWith(viewModel dataSource: Any?, indexPath: IndexPath?, delegate: Any?) {
        guard let dataSource = dataSource as? ChatTableViewCellViewModel else { return }
        
        self.dataSource = dataSource
        self.indexPath = indexPath
        
        constraintsList = [NSLayoutConstraint]()
        
        addSubview(bubble)
        addSubview(chatTextLabel)
        addSubview(dateLabel)
        
        setMessageLabel(information: dataSource)
        setMessageLabelConstraint(aling: dataSource.alignText)
        setBackground(aling: dataSource.alignText)
        dateLabel.text = getFormattedDate(date: dataSource.createdAt)
        
        let rightAnchorConstant = chatTextLabel.rightAnchor
        
        constraintsList?.append(contentsOf: [dateLabel.topAnchor.constraint(equalTo: chatTextLabel.bottomAnchor, constant: 0),
                                             dateLabel.rightAnchor.constraint(equalTo: rightAnchorConstant, constant: 0)
        ])
        
        constraintsList?.append(contentsOf: [bubble.topAnchor.constraint(equalTo: topAnchor, constant: 0),
                                             bubble.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
                                             bubble.rightAnchor.constraint(equalTo: rightAnchorConstant, constant: 6),
                                             bubble.leftAnchor.constraint(equalTo: chatTextLabel.leftAnchor, constant: -6)
        ])
        
        NSLayoutConstraint.activate(constraintsList ?? [NSLayoutConstraint]())
    }
    
    // MARK: - Private Methods
    
    /**
     Method to setup the Cell UI.
     */
    private func setupUI() {
        subviews.forEach({ $0.removeFromSuperview() })
        constraintsList = nil
        marginTopChatTextLabel = 6
    }
    
    public func calculateWidth(isDeleted: Bool) -> NSLayoutXAxisAnchor {
        let fontMessage = isDeleted ? Constant.deleteMessageFont : Constant.chatlabelfont
        let arrayWidth = chatTextLabel.text?.split(separator: "\n").map({ String($0).size(withAttributes: [.font: fontMessage]).width })
        let sizeMessage = arrayWidth?.max() ?? CGFloat(0)
        
        return chatTextLabel.rightAnchor
    }
    
    private func setMessageLabel(information: ChatTableViewCellViewModel) {
        chatTextLabel.text = information.chatMessage
        chatTextLabel.font = Constant.chatlabelfont
        chatTextLabel.textColor = Constant.textColor
    }
    
    private func setMessageLabelConstraint(aling: NSTextAlignment) {
        constraintsList?.append(contentsOf: [chatTextLabel.topAnchor.constraint(equalTo: topAnchor, constant: marginTopChatTextLabel),
                                             chatTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
                                             chatTextLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
                                             chatTextLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 40)])
        if aling == .left {
            constraintsList?.append(chatTextLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20))
        } else {
            constraintsList?.append(chatTextLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20))
        }
    }
    
    private func setBackground(aling: NSTextAlignment) {
        if aling == .left {
            bubble.backgroundColor = UIColor.Master.green
        } else {
            bubble.backgroundColor = UIColor.Master.greenDark
        }
    }
    
    private func getFormattedDate(date: String) -> String {
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = Constant.dateFormatted
        let date = formatterDate.date(from: date)
        let formatterHour = DateFormatter()
        formatterHour.dateFormat = Constant.hourFormatted
        formatterHour.locale = .current
        return formatterHour.string(from: date ?? Date())
    }
}

public struct ChatTableViewCellConstant {
    static let chatlabelfont = UIFont.systemFont(ofSize: 12.0)
    static let deleteMessageFont = UIFont.italicSystemFont(ofSize: 11)
    static let dateLabelFont = UIFont.systemFont(ofSize: 9.0)
    static let textColor: UIColor = .white
    
    static let dateFormatted = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    static let hourFormatted = "h:mm a"
    
}
