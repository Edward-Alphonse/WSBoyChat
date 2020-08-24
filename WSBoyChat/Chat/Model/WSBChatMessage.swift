//
//  WSBChatMessage.swift
//  WSBoyChat
//
//  Created by zhichang.he on 2020/8/14.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import Foundation

public enum WSBChatUserType {
    case me
    case other
}

public enum WSBChatMessageType: Int {
    case text = 0
    case gif = 1
}

public struct WSBChatUser {
    var name: String?
    var avatar: String?
    var type: WSBChatUserType = .me
}

class WSBChatMessage: NSObject {
    var user: WSBChatUser?
    var message: String?
    var gifName: String?
    var attMessage: NSMutableAttributedString?
    var type: WSBChatMessageType = .text
}
