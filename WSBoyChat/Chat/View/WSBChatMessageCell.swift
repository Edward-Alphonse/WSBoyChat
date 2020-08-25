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
        case nameLabel = "name_label"
        case messageLabel = "message_label"
        case gifImageView = "gif_image_view"
    }

    var viewModel: WSBChatMessageCellModel? {
        didSet {
            setCellModel()
        }
    }
    private var avatarView = WSBWebImageView(frame: .zero)
    private var nameLabel = UILabel(frame: .zero)
    private var messageLabel = UILabel(frame: .zero)
    private var gifimageView = WSBWebImageView()
    
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
        setupNameLabel()
        setupMessageLabel()
        setupGifImageView()
        
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
    
    func setupNameLabel() {
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textColor = UIColor.orange
        nameLabel.key = SubviewKey.nameLabel.rawValue
        contentView.addSubview(nameLabel)
    }
    
    func setupMessageLabel() {
        messageLabel.numberOfLines = 0
        messageLabel.key = SubviewKey.messageLabel.rawValue
        contentView.addSubview(messageLabel)
    }
    
    func setupGifImageView() {
        gifimageView.key = SubviewKey.gifImageView.rawValue
        contentView.addSubview(gifimageView)
    }
    
    func setCellModel() {
        guard let viewModel = viewModel else {
            return
        }
        avatarView.imageName = viewModel.isMe ? "1" : "2"
        avatarView.frame = viewModel[SubviewKey.avatarView]

        if viewModel.messageType == .text {
            messageLabel.attributedText = viewModel.message
            messageLabel.frame = viewModel[SubviewKey.messageLabel]
        }
    }
    
    @objc func tappedAvatarView() {
        
    }
}
