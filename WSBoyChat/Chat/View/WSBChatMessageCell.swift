//
//  WSBChatMessageCell.swift
//  WSBoyChat
//
//  Created by zhichang.he on 2020/8/14.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import UIKit

class WSBChatMessageCell: UITableViewCell {
    static let identifier = "WSBChatMessageCell"
    
    public enum SubviewKey: String {
        case avatarView = "avatar_view"
        case messageView = "message_label"
    }

    var viewModel: WSBChatMessageCellModel? {
        didSet {
            setCellModel()
        }
    }
    private var avatarView = WSBWebImageView(frame: .zero)
    private var messageView = WSBMessageContentView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadSubviews() {
        self.backgroundColor = BACKGROUND_Color
        setupAvatarView()
        setupMessageLabel()
    }
    
    func setupAvatarView() {
        //头像
        avatarView.layer.cornerRadius  = 5
        avatarView.layer.masksToBounds = true
        avatarView.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        avatarView.layer.borderWidth = 0.5
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedAvatarView))
        avatarView.addGestureRecognizer(tap)
        avatarView.isUserInteractionEnabled = true
        avatarView.key = SubviewKey.avatarView.rawValue
        contentView.addSubview(avatarView)
    }
    
    func setupMessageLabel() {
        messageView.key = SubviewKey.messageView.rawValue
        contentView.addSubview(messageView)
    }
    
    func setCellModel() {
        guard let viewModel = viewModel else {
            return
        }
        avatarView.imageName = viewModel.isMe ? "1" : "2"
        avatarView.frame = viewModel[SubviewKey.avatarView]

        if viewModel.messageType == .text {
            messageView.insets = viewModel.contentInsets
            messageView.textView.insets = viewModel.textViewInsets
            messageView.textView.textInsets = viewModel.textLabelInsets
            messageView.type = .text
            messageView.direction = viewModel.isMe ? .right : .left
            messageView.attributedText = viewModel.message
            messageView.frame = viewModel[SubviewKey.messageView]
        }
    }
    
    @objc func tappedAvatarView() {
        
    }
}
