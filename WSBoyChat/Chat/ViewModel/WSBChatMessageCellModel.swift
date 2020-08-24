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
        return model.user?.avatar
    }
    var message: NSAttributedString?
    fileprivate var frames = [WSBChatSubviewFrame]()
    fileprivate var model: WSBChatMessage
    var isMe: Bool {
        return  model.user?.type == .me
    }
    
    init(model: WSBChatMessage) {
        self.model = model
        layout()
    }
    
    fileprivate func layoutAvatarView() {
        let iconW: CGFloat    = 36.0
        let padding: CGFloat  = 8.0
        let iconH: CGFloat    = 36.0
        
        let iconFrameX: CGFloat = isMe ? padding : screenW - padding - iconW
        let iconFrameY: CGFloat = padding
        let iconFrameW: CGFloat = iconW
        let iconFrameH: CGFloat = iconH
        let iconFrame = CGRect(x: iconFrameX, y: iconFrameY, width: iconFrameW, height: iconFrameH)
        frames.append(WSBChatSubviewFrame(key: .avatarView, frame: iconFrame))
    }
    
    fileprivate func layoutMessageLabel() {
        let padding: CGFloat = 52
        var frame: CGRect = .zero
        self.message = nil
        if model.type == .text, let message = model.message {
            var xOffset: CGFloat = padding
            let result = Utility.stringSize(text: message, font: UIFont.systemFont(ofSize: 14), constrained: screenW - 2 * padding)
            
            let size = result.1
            if isMe {
                xOffset = screenW - padding - size.width
            }
            frame = CGRect(x: xOffset, y: 8.0, width: size.width, height: size.height)
            self.message = result.0
        }
        frames.append(WSBChatSubviewFrame(key: .messageLabel, frame: frame))
    }
    
//    fileprivate func layoutGifImageView() {
//        let padding: CGFloat = 52
//        var frame: CGRect = .zero
//        let height: CGFloat = 125
//        if model.type == .gif {
//             frame = CGRect(x: padding, y: 8.0, width: screenW - 2 * padding, height: 100)
//        }
//        frames.append(WSBChatSubviewFrame(key: .messageLabel, frame: frame))
//    }
    
    fileprivate func layout() {
        layoutAvatarView()
        layoutMessageLabel()
//        let type:Bool = message?.user?.type == .me
//            //头像
//            let iconFrameX:CGFloat = type ? padding : screenW - padding - iconW
//            let iconFrameY:CGFloat = padding
//            let iconFrameW:CGFloat = iconW
//            let iconFrameH:CGFloat = iconH
//            iconFrame  = CGRect.init(x: iconFrameX, y: iconFrameY, width: iconFrameW, height: iconFrameH)
//
//            //名字
//            nameFrame = type ? CGRect.init(x: iconFrame.maxX + padding, y: iconFrameY, width: 100, height: 25) : CGRect.init(x: screenW - padding * 2 - iconFrameW - 100, y: iconFrameY, width: 100, height: 25)
//
//            if message?.messageType == 0 {
//
//                //message
//                let str:String = (message?.message)!
//                let textAtt = LiuqsChageEmotionStrTool.changeStr(string: str, font: UIFont.systemFont(ofSize: 17.0), textColor: UIColor.black)
//                message?.attMessage = textAtt
//                let maxsize:CGSize = CGSize.init(width: Int(screenW - (iconFrameW + padding * 3) * 2), height: 1000)
//                let textSize:CGSize = textAtt.boundingRect(with: maxsize, options: .usesLineFragmentOrigin, context: nil).size
//                let emojiSize:CGSize = CGSize.init(width: textSize.width + padding * 2, height: textSize.height + padding * 2)
//                textFrame = type ? CGRect.init(x: padding * 2 + iconFrameW, y: iconFrameY + iconFrameH * 0.5, width: emojiSize.width, height: emojiSize.height) : CGRect.init(x: screenW - padding * 2 - iconFrameW - emojiSize.width, y: iconFrameY + iconFrameH * 0.5, width: emojiSize.width, height: emojiSize.height)
//                cellHeight = textFrame.maxY + padding;
//            }else if message?.messageType == 1 {
//
//                imageViewFrame = type ? CGRect.init(x: padding * 2 + iconFrameW, y: iconFrameY + iconFrameH * 0.5, width: 100, height: 100) : CGRect.init(x: screenW - padding * 2 - iconFrameW - 100, y: iconFrameY + iconFrameH * 0.5, width: 100, height: 100);
//
//                cellHeight = imageViewFrame.maxY + padding;
//
//            }else {
//
//
//            }
    }
    
    subscript(key: WSBChatMessageCell.SubviewKey) -> CGRect? {
        let results = frames.filter { $0.key == key}
        return results.first?.frame
    }
}
