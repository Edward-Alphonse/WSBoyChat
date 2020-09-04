//
//  CircleLoadingView.swift
//  WSBoyChat
//
//  Created by hezhichang on 2020/9/3.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import UIKit

open class CircleProgressView: UIView {
    // elements
    fileprivate let unfillLayer = CAShapeLayer()
    fileprivate let filledLayer = CAShapeLayer()
    fileprivate var progressLabel = UILabel()
    
    // setting args
    public var progress: Int = 0 {
        didSet {
            self.progressLabel.text = "\(progress)%"
            self.progressLabel.sizeToFit()
            self.filledLayer.strokeEnd = CGFloat(progress) / 100
        }
    }
    
    fileprivate var radius: CGFloat = 22.5
    fileprivate var lineWidth: CGFloat = 3
    
    fileprivate var undoColor: UIColor = UIColor(white: 1, alpha: 0.3)
    fileprivate var doneColor: UIColor = UIColor(white: 1, alpha: 1)

    public init(frame: CGRect, lineWidth: CGFloat = 3, progress: Int = 0) {
        super.init(frame: frame)
        self.lineWidth = lineWidth
        if frame.width > lineWidth {
            self.radius = (frame.width - lineWidth) / 2
        }
        self.progress = progress
        setupSubviews()
        drawUnfillCircle()
        drawFilledCircle()
    }

    public init() {
        super.init(frame: .zero)
    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    deinit {
        print("CircleProgressView deinit...")
    }

    fileprivate func setupSubviews() {
        progressLabel.font = UIFont.systemFont(ofSize: 12)
        progressLabel.textColor = .white
        progressLabel.layer.shadowColor = UIColor(hexString: "4c000000").cgColor
        progressLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        progressLabel.layer.shadowRadius = 3
        progressLabel.text = "\(progress)%"
        progressLabel.sizeToFit()
        self.addSubview(progressLabel)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        
        progressLabel.frame = CGRect(x: 0,
                                     y: 0,
                                     width: progressLabel.width,
                                     height: progressLabel.height)
        progressLabel.center = self.center
    }

    fileprivate func drawUnfillCircle() {

        let unfillPath: UIBezierPath
            = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: lineWidth/2,
                                                          y: lineWidth/2),
                                            size: CGSize(width: radius * 2,
                                                        height: radius * 2)))
        setupLayer(layer: unfillLayer, path: unfillPath, color: undoColor.cgColor)
        self.layer.addSublayer(unfillLayer)
    }

    fileprivate func drawFilledCircle() {           //progress: Int
        let startAngle: CGFloat = -CGFloat.pi / 2
        let endAngle: CGFloat = CGFloat.pi * 3 / 2
        let arcCenter: CGPoint = CGPoint(x: radius + lineWidth/2, y: radius + lineWidth/2)
        let filledPath: UIBezierPath
            = UIBezierPath(arcCenter: arcCenter,
                           radius: radius,
                           startAngle: startAngle,
                           endAngle: endAngle,
                           clockwise: true)
        setupLayer(layer: filledLayer, path: filledPath, color: doneColor.cgColor)
        self.layer.addSublayer(filledLayer)
        filledLayer.strokeStart = 0
        filledLayer.strokeEnd = CGFloat(progress) / 100
    }

    private func setupLayer(layer: CAShapeLayer, path: UIBezierPath, color: CGColor, lineRadius: CGFloat = 0) {
        layer.strokeColor = color
        layer.fillColor = UIColor.clear.cgColor
        layer.path = path.cgPath
        layer.lineWidth = lineWidth
        layer.lineCap = .round
        layer.lineJoin = .round
    }

    public func clearProgress() {
        self.progress = 0
    }
}

