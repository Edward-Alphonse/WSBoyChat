//
//  WSBUserRegisterViewController.swift
//  WSBoyChat
//
//  Created by hezhichang on 2020/8/6.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WSBUserRegisterViewController: WSBBaseViewController {
    var accountInputView = WSBLoginInputView(frame: .zero)
    var passwordInputView = WSBLoginInputView(frame: .zero)
    var passwordEnsureInputView = WSBLoginInputView(frame: .zero)
    var registerButton = UIButton(type: .custom)
    var viewModel = WSBUserRegisterViewModel()
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
        setupPasswordEnsureInputView()
        setupRegisterButton()
    }

    func configNavigationBar() {
        navigationBar.title = "新用户注册"
        navigationBar.backgroundColor = .white
    }

    func setupAccountInputView() {
        accountInputView.backgroundColor = .white
        accountInputView.titleLabel.text = "Email"
        accountInputView.textField.placeholder = "输入Email"
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
        passwordInputView.textField.placeholder = "输入密码"
        self.view.addSubview(passwordInputView)
        passwordInputView.snp.makeConstraints { (maker) in
            maker.top.equalTo(accountInputView.snp.bottom)
            maker.width.equalToSuperview()
            maker.height.equalTo(48)
        }
    }
    
    func setupPasswordEnsureInputView() {
        passwordEnsureInputView.backgroundColor = .white
        passwordEnsureInputView.titleLabel.text = "确认密码"
        passwordEnsureInputView.textField.placeholder = "再次输入密码"
        self.view.addSubview(passwordEnsureInputView)
        passwordEnsureInputView.snp.makeConstraints { (maker) in
            maker.top.equalTo(passwordInputView.snp.bottom)
            maker.width.equalToSuperview()
            maker.height.equalTo(48)
        }
    }
    
    func setupRegisterButton() {
        registerButton.setTitle("注册", for: .normal)
        registerButton.setTitleColor(.black, for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        registerButton.backgroundColor = .white
        registerButton.layer.cornerRadius = 24
        self.view.addSubview(registerButton)
        registerButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(passwordEnsureInputView.snp.bottom).offset(24)
            maker.left.equalToSuperview().offset(16)
            maker.right.equalToSuperview().offset(-16)
            maker.height.equalTo(48)
        }
    }
}

extension WSBUserRegisterViewController {
    func setupBindings() {
        accountInputView.textField.rx.text.orEmpty.changed.bind(to: viewModel.accountInputted).disposed(by: disposeBag)
        passwordInputView.textField.rx.text.orEmpty.changed.bind(to: viewModel.passwordInputted).disposed(by: disposeBag)
        passwordEnsureInputView.textField.rx.text.orEmpty.changed.bind(to: viewModel.passwordEnsureInputted).disposed(by: disposeBag)
        
        registerButton.rx.tap.bind(to: viewModel.registerButtonTapped).disposed(by: disposeBag)
        viewModel.passwordInputEnableSignal.emit(to: passwordInputView.textField.rx.isEnabled).disposed(by: disposeBag)
        viewModel.passwordEnsureInputEnableSignal.emit(to: passwordEnsureInputView.textField.rx.isEnabled).disposed(by: disposeBag)
        viewModel.registerButtonEnableSignal.emit(to: registerButton.rx.isEnabled).disposed(by: disposeBag)
        viewModel.toastSignal.emit(onNext: {[weak self] (text) in
            guard let text = text, !text.isEmpty else { return }
            self?.view.makeToastActivity(.center)
            self?.view.makeToast(text)
        }).disposed(by: disposeBag)
        viewModel.loadingSignal.emit(onNext: { [weak self] (type) in
            if type == WSBLoadingType.loading {
                self?.view.makeToastActivity(ToastPosition.center)
                return
            }
            self?.view.hideToastActivity()
        }).disposed(by: disposeBag)
    }
}

