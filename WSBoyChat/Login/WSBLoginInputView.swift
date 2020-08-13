//
//  WSBLoginInputView.swift
//  WSBoyChat
//
//  Created by hezhichang on 2020/8/6.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import Foundation
import UIKit

protocol WSBLoginInputViewDelegate: class {
    func didEndEding(_ textField: UITextField)
}

class WSBLoginInputView: UIView {
    weak var delegate: WSBLoginInputViewDelegate?
    fileprivate(set) var titleLabel = UILabel(frame: .zero)
    fileprivate(set) var textField = UITextField(frame: .zero)
    fileprivate(set) var bottomLineView = UIView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadSubviews() {
        setupTitleLabel()
        setupTextInputView()
        setupBottomLineView()
    }
    
    func setupTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .black
        addSubview(titleLabel)
    }
    
    func setupTextInputView() {
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.delegate = self
        addSubview(textField)
    }
    
    func setupBottomLineView() {
        bottomLineView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        addSubview(bottomLineView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomLineView.frame = CGRect(x: 0, y: self.height - 0.5, width: self.width, height: 0.5)
        titleLabel.frame = CGRect(x: 16, y: 0, width: 80, height: self.height)
        textField.frame = CGRect(x: titleLabel.right, y: 0, width: self.width - titleLabel.right - 8, height: self.height)
    }
}

extension WSBLoginInputView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.didEndEding(textField)
    }
}
