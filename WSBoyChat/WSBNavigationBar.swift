//
//  WSBNavigationBar.swift
//  WSBoyChat
//
//  Created by hezhichang on 2020/8/5.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import Foundation
import UIKit

protocol WSBNavigationBarDelegate: class {
    func dismiss()
}

class WSBNavigationBar: UIView {

    weak var delegate: WSBNavigationBarDelegate?
    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
            layoutIfNeeded()

        }
    }
    fileprivate var titleLabel = UILabel(frame: .zero)
    fileprivate(set) var backButton = UIButton(type: .custom)
    fileprivate(set) var rightButtons = [UIButton]()
    fileprivate(set) var bottomLineView = UIView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func loadSubviews() {
        setupTitleLabel()
        setupBackButton()
        setupBottomLineView()
    }

    fileprivate func setupTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        addSubview(titleLabel)
    }
    
    fileprivate func setupBackButton() {
        backButton.titleLabel?.textColor = .black
        let image = UIImage(named: "wsb_back")
        backButton.setImage(image, for: .normal)
        backButton.addTarget(self, action: #selector(clickBackButton(button:)), for: .touchUpInside)
        addSubview(backButton)
    }
    
    fileprivate func setupBottomLineView() {
        bottomLineView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        addSubview(bottomLineView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backButton.frame = CGRect(x: 6.5, y: 0, width: 44, height: self.height)
        bottomLineView.frame = CGRect(x: 0, y: self.height - 0.5, width: self.width, height: 0.5)
        let constrainedSize = CGSize(width: self.width - 2 * backButton.right, height: self.height)
        titleLabel.size = titleLabel.sizeThatFits(constrainedSize)
        titleLabel.center = self.inCenter
    }
    
    @objc func clickBackButton(button: UIButton) {
        delegate?.dismiss()
    }
}
