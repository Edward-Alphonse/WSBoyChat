//
//  WSBMessageContentView.swift
//  WSBoyChat
//
//  Created by zhichang.he on 2020/8/25.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import UIKit

class WSBMessageContentView: UIView {
    enum ContentType: Int {
        case text = 0
        case image = 1
    }
    
    enum Direction {
        case left
        case right
        case none
    }
    
    var insets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    var type: ContentType? {
        didSet {
            guard let type = type else {
                return
            }
            switch type {
            case .text:
                textView.removeFromSuperview()
                addSubview(textView)
            case .image:
                imageView.removeFromSuperview()
                addSubview(imageView)
            }
        }
    }
    var direction: Direction = .none
    var attributedText: NSAttributedString? {
        didSet {
            textView.attributedText = attributedText
            textView.direction = direction.convertToMessageTextViewDirecton()
        }
    }
    fileprivate(set) lazy var textView: WSBMessageTextView = {
        let view = WSBMessageTextView(frame: .zero)
        return view
    }()
    
    fileprivate(set) var imageView: WSBWebImageView = {
        let imageView = WSBWebImageView(frame: .zero)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadSubviews() {

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let contentFrame = CGRect(x: insets.left, y: insets.top, width: self.width - insets.horizon, height: self.height - insets.vertical)
        switch type {
        case .text:
            textView.frame = contentFrame
        case .image:
            imageView.frame = contentFrame
        case .none:
            return
        }
    }
    
}

extension WSBMessageContentView.Direction {
    func convertToMessageTextViewDirecton() -> WSBMessageTextView.Direction {
        switch self {
        case .left:
            return WSBMessageTextView.Direction.left
        case .right:
            return WSBMessageTextView.Direction.right
        case .none:
            return WSBMessageTextView.Direction.none
        }
    }
}

class WSBMessageTextView: UIView {
    enum Direction {
        case left
        case right
        case none
    }
    var insets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    var textInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    var attributedText: NSAttributedString? {
           didSet {
               textLabel.attributedText = attributedText
           }
       }
    var contentView = UIView(frame: .zero)
    var textLabel = UILabel(frame: .zero)
    var arrowView = UIView(frame: .zero)
    var direction = Direction.none
    let arrowWidth: CGFloat = 4
    let arrowHeight: CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadSubviews() {
        setupContentView()
        setupArrowView()
    }
    
    func setupContentView() {
        setupTextLabel()
        addSubview(contentView)
    }
    
    func setupTextLabel() {
        textLabel.numberOfLines = 0
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        contentView.backgroundColor = .green
        contentView.addSubview(textLabel)
    }
    
    func setupArrowView() {
        arrowView.backgroundColor = .blue
        addSubview(arrowView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switch direction {
        case .left:
            arrowView.frame = CGRect(x: insets.left, y: insets.top, width: arrowWidth, height: arrowHeight)
            contentView.frame = CGRect(x: arrowView.right, y: insets.top, width: self.width - insets.horizon - arrowWidth, height: self.height - insets.vertical)
            
        case .right:
            contentView.frame = CGRect(x: insets.left, y: insets.top, width: self.width - insets.horizon - arrowWidth, height: self.height - insets.vertical)
            arrowView.frame = CGRect(x: contentView.right, y: insets.top, width: arrowWidth, height: arrowHeight)
        case .none:
            return
            
        }
        textLabel.frame = CGRect(x: textInsets.left, y: textInsets.top, width: contentView.width - textInsets.horizon, height: contentView.height - textInsets.vertical)
    }
}
