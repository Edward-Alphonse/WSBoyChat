//
//  WSBChatMessageCellModel.swift
//  WSBoyChat
//
//  Created by zhichang.he on 2020/8/24.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import Foundation
import UIKit

//class WSBChatSubviewFrame {
//    var key: String?
//    var frame: CGRect?
//}

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
    fileprivate var inset = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    
    convenience init(model: WSBChatMessage) {
        self.init()
        self.model = model
        layout()
    }
    
    init() {}
    
    fileprivate func layoutAvatarView() {
        let size: CGFloat    = 36.0
        let xOffset: CGFloat = !isMe ? inset.left : screenW - inset.right - size
        let yOffset: CGFloat = inset.top
        let iconFrame = CGRect(x: xOffset, y: yOffset, width: size, height: size)
        frames.append(WSBChatSubviewFrame(key: .avatarView, frame: iconFrame))
    }
    
    fileprivate func layoutMessageLabel() {
        guard let model = model else {
            return
        }
        let padding: CGFloat = 44
        var frame: CGRect = .zero
        self.message = nil
        if model.type == .text, let message = model.message {
            var xOffset: CGFloat = inset.left + padding
            let result = Utility.stringSize(text: message, font: UIFont.systemFont(ofSize: 14), constrained: screenW - 2 * padding - inset.horizon)
            
            let size = result.1
            if isMe {
                xOffset = screenW - inset.right - padding - size.width
            }
            let yOffset: CGFloat = inset.top
            frame = CGRect(x: xOffset, y: yOffset, width: size.width, height: size.height)
            self.message = result.0
        }
        frames.append(WSBChatSubviewFrame(key: .messageLabel, frame: frame))
    }
    
    fileprivate func layout() {
        layoutAvatarView()
        layoutMessageLabel()
        
        let avatarHeight: CGFloat = self[WSBChatMessageCell.SubviewKey.avatarView].height
        let messageHeight: CGFloat = self[WSBChatMessageCell.SubviewKey.messageLabel].height
        height = max(avatarHeight, messageHeight)
        height += inset.vertical
    }
    
    subscript(key: WSBChatMessageCell.SubviewKey) -> CGRect {
        let results = frames.filter { $0.key == key}
        return results.first?.frame ?? .zero
    }
}
