//
//  UIView+CGRect.swift
//  WSBoyChat
//
//  Created by hezhichang on 2020/8/5.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var x: CGFloat {
        set {
            self.frame.origin = CGPoint(x: newValue, y: self.y)
        }
        get {
            return self.frame.origin.x
        }
    }
    var y: CGFloat {
        set {
            self.frame.origin = CGPoint(x: self.x, y: newValue)
        }
        get {
            return self.frame.origin.y
        }
    }
    var width: CGFloat {
        set {
            self.frame.size = CGSize(width: newValue, height: self.height)
        }
        get {
            return self.frame.width
        }
    }
    
    var height: CGFloat {
        set {
            self.frame.size = CGSize(width: self.width, height: newValue)
        }
        get {
            return self.frame.height
        }
    }
    
    var left: CGFloat {
        return self.frame.minX
    }
    
    var right: CGFloat {
        return self.frame.maxX
    }
    
    var top: CGFloat {
        return self.frame.minY
    }
    
    var bottom: CGFloat {
        return self.frame.maxY
    }
    
    var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            self.frame.origin = newValue
        }
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            self.frame.size = newValue
        }
    }
    
    var inCenter: CGPoint {
        return CGPoint(x: self.width / 2, y: self.height / 2)
    }
    
    var center: CGPoint {
        get {
            let x = self.left + self.width / 2
            let y = self.top + self.height / 2
            return CGPoint(x: x, y: y)
        }
        set {
            let x = newValue.x - self.width / 2
            let y = newValue.y - self.height / 2
            self.origin = CGPoint(x: x, y: y)
        }
    }
}
