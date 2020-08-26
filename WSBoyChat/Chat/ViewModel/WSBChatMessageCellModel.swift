//
//  WSBChatMessageCellModel.swift
//  WSBoyChat
//
//  Created by zhichang.he on 2020/8/24.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import Foundation
import UIKit

struct WSBChatSubviewFrame {
    var key: WSBChatMessageCell.SubviewKey
    var frame: CGRect
    
    init(key: WSBChatMessageCell.SubviewKey, frame: CGRect) {
        self.key = key
        self.frame = frame
    }
}

class WSBChatMessageCellModel {
    var height: CGFloat = 0
    var avatarUrl: String? {
        return model?.user?.avatar
    }
    var message: NSAttributedString?
    var isMe: Bool {
        return  model?.user?.type == .me
    }
    var messageType: WSBChatMessageType {
        return model?.type ?? .text
    }
    var model: WSBChatMessage? {
        didSet {
            layout()
        }
    }
    
    fileprivate var frames = [WSBChatSubviewFrame]()
    fileprivate var insets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    fileprivate(set) var contentInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    fileprivate(set) var textViewInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 0)
    fileprivate(set) var textLabelInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    fileprivate let avatarSize: CGFloat = 36
    
    convenience init(model: WSBChatMessage) {
        self.init()
        self.model = model
        layout()
    }
    
    init() {}
    
    fileprivate func layoutAvatarView() {
        let xOffset: CGFloat = !isMe ? insets.left : screenW - insets.right - avatarSize
        let yOffset: CGFloat = insets.top
        let iconFrame = CGRect(x: xOffset, y: yOffset, width: avatarSize, height: avatarSize)
        frames.append(WSBChatSubviewFrame(key: .avatarView, frame: iconFrame))
    }
    
    fileprivate func layoutMessageLabel() {
        guard let model = model else {
            return
        }
        let padding: CGFloat = avatarSize
        var frame: CGRect = .zero
        self.message = nil
        if model.type == .text, let message = model.message {
            if isMe {
                contentInsets.left = 8
                contentInsets.right = 4
            } else {
                contentInsets.left = 4
                contentInsets.right = 8
            }
            var xOffset: CGFloat = insets.left + padding
            let constrainedWidth: CGFloat = screenW - 2 * avatarSize - insets.horizon - contentInsets.horizon - textViewInsets.horizon - textLabelInsets.horizon - 4
            let result = Utility.stringSize(text: message, font: UIFont.systemFont(ofSize: 14), constrained: constrainedWidth)
            
            var size = result.1
            size = CGSize(width: ceil(size.width), height: ceil(size.height))
            var width: CGFloat = screenW - 2 * avatarSize - insets.horizon
            width = min(size.width + textLabelInsets.horizon + textViewInsets.horizon + contentInsets.horizon, width)
            let height: CGFloat = size.height + contentInsets.vertical + textViewInsets.vertical + textLabelInsets.vertical
            if isMe {
                xOffset = screenW - insets.right - padding - width
            }
            let yOffset: CGFloat = insets.top
            frame = CGRect(x: xOffset, y: yOffset, width: width, height: height)
            self.message = result.0
        }
        frames.append(WSBChatSubviewFrame(key: .messageView, frame: frame))
    }
    
    fileprivate func layout() {
        layoutAvatarView()
        layoutMessageLabel()
        
        let avatarHeight: CGFloat = self[WSBChatMessageCell.SubviewKey.avatarView].height
        let messageHeight: CGFloat = self[WSBChatMessageCell.SubviewKey.messageView].height
        height = max(avatarHeight, messageHeight)
        height += insets.vertical
    }
    
    subscript(key: WSBChatMessageCell.SubviewKey) -> CGRect {
        let results = frames.filter { $0.key == key}
        return results.first?.frame ?? .zero
    }
}
