//
//  WSBLoginViewController.swift
//  WSBoyChat
//
//  Created by hezhichang on 2020/8/4.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WSBLoginViewController: WSBBaseViewController {
    
    var titleLabel = UILabel(frame: .zero)
    var accountInputView = WSBLoginInputView(frame: .zero)
    var passwordInputView = WSBLoginInputView(frame: .zero)
    var loginButton = UIButton(type: .custom)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        // Do any additional setup after loading the view.
    }
    
    func setupSubviews() {
        self.view.backgroundColor = UIColor(hexString: "#EDEEF0")
        configNavigationBar()
        setupAccountInputView()
        setupPasswordInputView()
        setupLoginButton()
    }
    
    func configNavigationBar() {
        navigationBar.backButton.isHidden = true
        navigationBar.title = "登录"
        navigationBar.backgroundColor = .white
    }
    
    func setupAccountInputView() {
        accountInputView.backgroundColor = .white
        accountInputView.titleLabel.text = "账号"
        accountInputView.textField.placeholder = "Email账号"
        accountInputView.layer.borderWidth = 0.5
        accountInputView.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        accountInputView.bottomLineView.isHidden = true
        self.view.addSubview(accountInputView)
        accountInputView.snp.makeConstraints { (maker) in
            maker.top.equalTo(navigationBar.snp.bottom).offset(16)
            maker.width.equalToSuperview()
            maker.height.equalTo(48)
        }
    }
    
    func setupPasswordInputView() {
        passwordInputView.backgroundColor = .white
        passwordInputView.titleLabel.text = "密码"
        passwordInputView.textField.placeholder = "密码"
        self.view.addSubview(passwordInputView)
        passwordInputView.snp.makeConstraints { (maker) in
            maker.top.equalTo(accountInputView.snp.bottom)
            maker.width.equalToSuperview()
            maker.height.equalTo(48)
        }
    }
    
    func setupLoginButton() {
        loginButton.setTitle("登录", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        loginButton.backgroundColor = .white
        loginButton.layer.cornerRadius = 24
        self.view.addSubview(loginButton)
        loginButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(passwordInputView.snp.bottom).offset(24)
            maker.leftMargin.equalToSuperview().offset(16)
            maker.rightMargin.equalToSuperview().offset(-16)
            maker.height.equalTo(48)
        }
    }
}


class WSBLoginInputView: UIView {
    fileprivate(set) var titleLabel = UILabel(frame: .zero)
    fileprivate(set) var textField = UITextField(frame: .zero)
    fileprivate var bottomLineView = UIView(frame: .zero)
    
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
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
    }
    
    func setupTextInputView() {
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16)
        addSubview(textField)
    }
    
    func setupBottomLineView() {
        bottomLineView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        addSubview(bottomLineView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomLineView.frame = CGRect(x: 0, y: self.height - 0.5, width: self.width, height: 0.5)
        titleLabel.frame = CGRect(x: 0, y: 0, width: 80, height: self.height)
        textField.frame = CGRect(x: titleLabel.right, y: 0, width: self.width - titleLabel.right - 8, height: self.height)
    }
}
