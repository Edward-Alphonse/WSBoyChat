//
//  Utility.swift
//  WSBoyChat
//
//  Created by hezhichang on 2020/8/5.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import Foundation
import UIKit

struct Utility {
    public static func getScreenSize() -> CGSize {
        let size = UIScreen.main.bounds.size
        return size
    }

    public static func is320WidthScreen() -> Bool {
        return UIScreen.main.bounds.width == 320
    }

    public static func is375WidthScreen() -> Bool {
        return UIScreen.main.bounds.width == 375
    }

    public static func is414WidthScreen() -> Bool {
        return UIScreen.main.bounds.width == 414
    }

    public static func isShortSizedScreen() -> Bool {
        return UIScreen.main.bounds.width == 320
    }

    public static func is667SizedScreen() -> Bool {
        return UIScreen.main.bounds.height == 667
    }

    public static func is736SizedScreen() -> Bool {
        return UIScreen.main.bounds.height == 736
    }

    public static func isLargeScreen() -> Bool {
        return (UIScreen.main.bounds.height >= 667
           || UIScreen.main.bounds.width >= 667)
    }

    public static func isiPhoneX() -> Bool {
        guard UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone else {
            return false
        }
        var iPhoneXSeries = false
        if #available(iOS 11.0, *) {
            iPhoneXSeries = (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) > 0
        }
        return iPhoneXSeries
    }

    public static func isiPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    public static func navigationBarHeight() -> CGFloat {
        return isiPhoneX() ? 92 : 68
    }
    
    public static func defaultStatusBarHeight() -> CGFloat {
        return isiPhoneX() ? 44 : 20
    }

    static func defaultContentHeight() -> CGFloat {
        return isiPhoneX() ? 48 : 48
    }

    public static func tabBarHeight() -> CGFloat {
       return isiPhoneX() ? (34 + 49) : 49
    }

    public static func safeAreaBottom() -> CGFloat {
       var margin: CGFloat = 0
       if #available(iOS 11.0, *) {
           margin = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
       }
       return margin
    }
}


extension Utility {
    static func stringSize(text: String, font: UIFont, constrained width: CGFloat) -> (NSAttributedString, CGSize) {
        var attributes = [NSAttributedString.Key: Any]()
        attributes[NSAttributedString.Key.font] = font
        let attributeString = NSAttributedString(string: text, attributes: attributes)
        let options : NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let size = attributeString.boundingRect(with: CGSize(width: width, height: 999), options: options, context: nil).size
        return (attributeString, size)
    }
}

public extension UIEdgeInsets {
    var horizon: CGFloat {
        return self.left + self.right
    }
    var vertical: CGFloat {
        return self.top + self.bottom
    }
}
