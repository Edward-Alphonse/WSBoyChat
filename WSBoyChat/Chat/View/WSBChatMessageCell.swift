//
//  WSBChatMessageCell.swift
//  WSBoyChat
//
//  Created by zhichang.he on 2020/8/14.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import UIKit

//public enum WSBChatMessageCellSubviewKey: String {
//    case
//}

//public struct WSBChatMessageCellSubviewKey: RawRepresentable {
//    public typealias RawValue = String
//    public typealias SubviewKey = WSBChatMessageCellSubviewKey
//
//    public static var avatarView = SubviewKey(rawValue: "avatar_view")
//    public static var nameLabel = SubviewKey(rawValue: "name_label")
//    public static var messageLabel = SubviewKey(rawValue: "message_label")
//    public static var gifimageView = SubviewKey(rawValue: "gif_image_view")
//
//    public var rawValue: String
//    public init?(rawValue: String) {
//        self.rawValue = rawValue
//    }
//}

enum SubviewKey: Int {
    case a = 0
}

class WSBChatMessageCell: UITableViewCell {
    static let identifier = "WSBChatMessageCell"
    
    public enum SubviewKey: String {
        case avatarView = "avatar_view"
        case nameLabel = "name_label"
        case messageLabel = "message_label"
        case gifImageView = "gif_image_view"
    }

    var viewModel: WSBChatMessageCellModel?
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
    
    var chatCellFrame:LiuqsChatCellFrame? {
        
        didSet {
            
            let type: Bool = chatCellFrame?.message?.user?.type == .me
            
            //头像
            avatarView.imageName = type ? "1" : "2"
            avatarView.frame = (chatCellFrame?.iconFrame)!
            //名字
            nameLabel.text = chatCellFrame?.message?.user?.name
            nameLabel.frame = (chatCellFrame?.nameFrame)!
            nameLabel.textAlignment = type ? NSTextAlignment.left : NSTextAlignment.right
            
            if chatCellFrame?.message?.messageType == 0 {
                
                //消息内容
//                messageLabel.setAttributedTitle(chatCellFrame?.message?.attMessage, for: UIControl.State.normal)
                messageLabel.attributedText = chatCellFrame?.message?.attMessage
                messageLabel.frame = (chatCellFrame?.textFrame)!
                let messageImageName: String = type ? "chat_receive_nor" : "chat_send_nor"
                let messageImageNameP: String = type ? "chat_receive_p" : "chat_send_p"
//                messageLabel.setBackgroundImage(UIImage.resizebleImage(imageName: messageImageName), for: UIControl.State.normal)
//                messageLabel.setBackgroundImage(UIImage.resizebleImage(imageName: messageImageNameP), for: UIControl.State.highlighted)
//                messageLabel.titleEdgeInsets = type ? UIEdgeInsets(top: 7, left: 13, bottom: 5, right: 5) : UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 13)
                gifimageView.frame = CGRect()
                
            }   else if chatCellFrame?.message?.messageType == 1 {
                
                let path:String = Bundle.main.path(forResource: chatCellFrame?.message?.gifName, ofType: "gif")!
                
                let data = NSData.init(contentsOf: NSURL.init(fileURLWithPath: path) as URL)
                
                let animationImage = UIImage.animationImageWithData(data: data);
             
                gifimageView.image =  animationImage;
                
                gifimageView.frame = (chatCellFrame?.imageViewFrame)!
                
                messageLabel.frame = CGRect()
            }
            
        }
    }
    
    @objc func tappedAvatarView() {
        
    }
}
