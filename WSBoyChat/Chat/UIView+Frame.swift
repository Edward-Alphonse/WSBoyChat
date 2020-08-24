//
//  UIView+Frame.swift
//  WSBoyChat
//
//  Created by zhichang.he on 2020/8/24.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import UIKit

extension UIView {
    static var associateKey: String = "WSBViewKey"
    var key: String? {
        set {
            objc_setAssociatedObject(self, &UIView.associateKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, &UIView.associateKey) as? String
        }
    }
}
