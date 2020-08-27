//
//  FSArrowView.swift
//  WSBoyChat
//
//  Created by hezhichang on 2020/8/26.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import UIKit

class FSArrowView: UIView {
    
    enum Direction {
        case up
        case down
        case left
        case right
    }
    var direction: Direction = .down
    fileprivate var triangleLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hexString: "#f5f6f6")
        self.layer.mask = triangleLayer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawArrow()
    }
    
    func drawArrow() {
        switch direction {
        case .up:
            drawArrowForUpDirection()
        case .down:
            drawArrowForDownDirection()
        case .left:
            drawArrowForLeftDirection()
        case .right:
            drawArrowForRightDirection()
        }
    }
    
    func drawArrowForUpDirection() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: bounds.height))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        path.addLine(to: CGPoint(x: bounds.width / 2, y: 0))
        path.close()
        triangleLayer.path = path.cgPath
    }
    
    func drawArrowForDownDirection() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: bounds.width / 2, y: bounds.height))
        path.addLine(to: CGPoint(x: bounds.width, y: 0))
        path.close()
        triangleLayer.path = path.cgPath
    }
    
    func drawArrowForLeftDirection() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.width, y: 0))
        path.addLine(to: CGPoint(x: 0, y: bounds.height / 2))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        path.close()
        triangleLayer.path = path.cgPath
    }
    
    func drawArrowForRightDirection() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x:0 , y: 0))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height / 2))
        path.addLine(to: CGPoint(x: 0, y: bounds.height))
        path.close()
        triangleLayer.path = path.cgPath
    }
}
