//
//  ViewController.swift
//  WSBoyChat
//
//  Created by zhichang.he on 2020/7/29.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    
//    var button = UIButton(frame: )
    var button = UIButton(type: .custom)
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        button.setTitle("登录", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 15
        self.view.addSubview(button)
        button.snp.makeConstraints { (maker) in
            maker.width.equalTo(60)
            maker.height.equalTo(45)
            maker.center.equalToSuperview()
        }
        button.rx.tap.bind {[weak self] () in
            let loginViewController = WSBLoginViewController()
//            self?.present(loginViewController, animated: true, completion: nil)
            let viewController = WSBNavigationViewController(rootViewController: loginViewController)
            viewController.modalPresentationStyle = .fullScreen
            self?.present(viewController, animated: true, completion: nil)
            
        }.disposed(by: disposeBag)
    }
    
    

}

