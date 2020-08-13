//
//  WSBUserRegisterViewModel.swift
//  WSBoyChat
//
//  Created by hezhichang on 2020/8/6.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class WSBUserRegisterViewModel {
    //input
    var registerButtonTapped = PublishRelay<Void>()
    var accountInputted = PublishRelay<String>()
    var passwordInputted = PublishRelay<String>()
    var passwordEnsureInputted = PublishRelay<String>()
    
    //output
    var passwordInputEnableSignal: Signal<Bool> {
        return passwordInputEnableRelay.asSignal(onErrorJustReturn: true)
    }
    var passwordEnsureInputEnableSignal: Signal<Bool> {
        return passwordEnsureInputEnableRelay.asSignal(onErrorJustReturn: true)
    }
    var registerButtonEnableSignal: Signal<Bool> {
        return registerButtonEnableRelay.asSignal(onErrorJustReturn: true)
    }
    var toastSignal: Signal<String?> {
        return toastRelay.asSignal(onErrorJustReturn: nil)
    }
    var loadingSignal: Signal<WSBLoadingType> {
        return loadingRelay.asSignal(onErrorJustReturn: .normal)
    }
    //internal
    fileprivate var passwordInputEnableRelay = BehaviorRelay<Bool>(value: false)
    fileprivate var passwordEnsureInputEnableRelay = BehaviorRelay<Bool>(value: false)
    fileprivate var registerButtonEnableRelay = BehaviorRelay<Bool>(value: false)
    fileprivate var toastRelay = BehaviorRelay<String?>(value: nil)
    fileprivate var loadingRelay = BehaviorRelay<WSBLoadingType>(value: .normal)
    var account: String?
    var password: String?
    var disposeBag = DisposeBag()
    
    init() {
        setupBindings()
    }
    
    func setupBindings() {
        registerButtonTapped.subscribe(onNext: {[weak self] () in
            self?.register()
        }).disposed(by: disposeBag)
        
        accountInputted.subscribe(onNext: {[weak self] (account) in
            self?.passwordInputEnableRelay.accept(!account.isEmpty)
            self?.account = account
        }).disposed(by: disposeBag)
        
        passwordInputted.subscribe(onNext: {[weak self] (password) in
            self?.passwordEnsureInputEnableRelay.accept(!password.isEmpty)
            self?.password = password
        }).disposed(by: disposeBag)
        
        passwordEnsureInputted.subscribe(onNext: {[weak self] (password) in
            guard let `self` = self else {
                return
            }
            self.registerButtonEnableRelay.accept(!password.isEmpty || password != self.password)
        }).disposed(by: disposeBag)
    }
    
    func register() {
        var params = [String: Any]()
        params["username"] = self.account
        params["password"] = self.password
        loadingRelay.accept(.loading)
        WSBLoginService.shared.register(params) {[weak self] (data, response, error) in
            self?.loadingRelay.accept(.normal)
            if let err = error as NSError? {
                let msg = err.userInfo["NSLocalizedDescription"] as? String
                self?.toastRelay.accept(msg)
                return
            }
        }
    }
}
