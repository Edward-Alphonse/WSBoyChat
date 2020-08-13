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
    var accountInputView = WSBLoginInputView(frame: .zero)
    var passwordInputView = WSBLoginInputView(frame: .zero)
    var registerButton = UIButton(type: .custom)
    var loginButton = UIButton(type: .custom)
    var viewModel = WSBLoginViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupBindings()
    }
    
    func setupSubviews() {
        self.view.backgroundColor = UIColor(hexString: "#EDEEF0")
        configNavigationBar()
        setupAccountInputView()
        setupPasswordInputView()
        setupLoginButton()
        setupRegisterButton()
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
            maker.left.equalToSuperview().offset(16)
            maker.right.equalToSuperview().offset(-16)
            maker.height.equalTo(48)
        }
    }
    
    func setupRegisterButton() {
        registerButton.setTitle("新用户注册", for: .normal)
        registerButton.setTitle("新用户注册", for: .highlighted)
        registerButton.setTitleColor(.blue, for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        registerButton.sizeToFit()
        self.view.addSubview(registerButton)
        registerButton.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-16)
            maker.top.equalTo(loginButton.snp.bottom).offset(10)
        }
    }
}

extension WSBLoginViewController {
    func setupBindings() {
        accountInputView.textField.rx.text.orEmpty.changed.bind(to: viewModel.accountInputted).disposed(by: disposeBag)
        passwordInputView.textField.rx.text.orEmpty.changed.bind(to: viewModel.passwordInputted).disposed(by: disposeBag)
        loginButton.rx.tap.bind(to: viewModel.loginButtonTapped).disposed(by: disposeBag)
        registerButton.rx.tap.subscribe(onNext: {[weak self] () in
            self?.gotoRegister()
        }).disposed(by: disposeBag)
        viewModel.passwordInputEnableSignal.emit(to: passwordInputView.textField.rx.isEnabled).disposed(by: disposeBag)
        viewModel.loginButtonEnableSignal.emit(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
        viewModel.toastSignal.emit(onNext: {[weak self] (text) in
            guard let text = text, !text.isEmpty else { return }
            self?.view.makeToast(text, duration: 0.5, position: ToastPosition.center, title: nil, image: nil, style: ToastStyle(), completion: nil)
        }).disposed(by: disposeBag)
        viewModel.loadingSignal.emit(onNext: { [weak self] (type) in
            if type == WSBLoadingType.loading {
                self?.view.makeToastActivity(ToastPosition.center)
                return
            }
            self?.view.hideToastActivity()
        }).disposed(by: disposeBag)
    }
    
    func gotoRegister() {
        let viewControlelr = WSBUserRegisterViewController()
        self.push(viewController: viewControlelr)
    }
}
