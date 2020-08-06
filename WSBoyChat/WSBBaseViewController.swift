//
//  WSBBaseViewController.swift
//  WSBoyChat
//
//  Created by hezhichang on 2020/8/5.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import UIKit

class WSBBaseViewController: UIViewController, WSBNavigationBarDelegate {
    var navigationBar = WSBNavigationBar(frame: .zero)
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSubviews()
    }
    
    fileprivate func loadSubviews() {
        setupNavigationBar()
    }
    
    fileprivate func setupNavigationBar() {
        navigationBar.frame = CGRect(x: 0, y: Utility.defaultStatusBarHeight(), width: self.view.width, height: Utility.defaultContentHeight())
        navigationBar.delegate = self
        self.view.addSubview(navigationBar)
    }
}

extension UIViewController {
    open func dismiss() {
        self.navigationController?.popViewController(animated: true)
    }
}
