//
//  WSBLoginViewModel.swift
//  WSBoyChat
//
//  Created by hezhichang on 2020/8/4.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public enum WSBLoadingType {
    case loading
    case normal
}

class WSBLoginViewModel {
    //input
    var loginButtonTapped = PublishRelay<Void>()
    var accountInputted = PublishRelay<String>()
    var passwordInputted = PublishRelay<String>()
    
    //output
    var passwordInputEnableSignal: Signal<Bool> {
        return passwordInputEnableRelay.asSignal(onErrorJustReturn: true)
    }
    var loginButtonEnableSignal: Signal<Bool> {
        return loginButtonEnableRelay.asSignal(onErrorJustReturn: true)
    }
    var toastSignal: Signal<String?> {
        return toastRelay.asSignal(onErrorJustReturn: nil)
    }
    var loadingSignal: Signal<WSBLoadingType> {
        return loadingRelay.asSignal(onErrorJustReturn: .normal)
    }
    
    //internal
    fileprivate var passwordInputEnableRelay = BehaviorRelay<Bool>(value: false)
    fileprivate var loginButtonEnableRelay = BehaviorRelay<Bool>(value: false)
    fileprivate var toastRelay = BehaviorRelay<String?>(value: nil)
    fileprivate var loadingRelay = BehaviorRelay<WSBLoadingType>(value: .normal)
    fileprivate var account: String?
    fileprivate var password: String?
    fileprivate var disposeBag = DisposeBag()
    fileprivate var cellModels = [WSBLoginViewCellModelType]()
    
    
    init() {
        setupBindings()
    }
    
    func setupBindings() {
        loginButtonTapped.subscribe(onNext: {[weak self] () in
            self?.login()
        }).disposed(by: disposeBag)
        
        accountInputted.subscribe(onNext: {[weak self] (account) in
            self?.passwordInputEnableRelay.accept(!account.isEmpty)
            self?.account = account
        }).disposed(by: disposeBag)
        
        passwordInputted.subscribe(onNext: {[weak self] (password) in
            self?.loginButtonEnableRelay.accept(!password.isEmpty)
            self?.password = password
            
        }).disposed(by: disposeBag)
    }
    
    func login() {
        var params = [String: Any]()
        params["username"] = self.account
        params["password"] = self.password
        loadingRelay.accept(.loading)
        WSBLoginService.shared.register(params) { [weak self] (data, response, error) in
            self?.loadingRelay.accept(.normal)
            if let err = error as NSError? {
                let msg = err.userInfo["NSLocalizedDescription"] as? String
                self?.toastRelay.accept(msg)
                return
            }
        }
    }
}

protocol WSBLoginViewCellModelType {
    var title: String { get set }
    var placeholder: String { get set }
}


class WSBLoginViewAccountCellModel: WSBLoginViewCellModelType {
    var title: String = "账号"
    var placeholder: String = "请输入Email账号"
    
    init() {
        
    }
}

class WSBLoginViewPasswordCellModel: WSBLoginViewCellModelType {
    var title: String = "密码"
    var placeholder: String = "请输入密码"
    init() {
        
    }
    
}

