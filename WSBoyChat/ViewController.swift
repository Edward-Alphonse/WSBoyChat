//
//  ViewController.swift
//  WSBoyChat
//
//  Created by zhichang.he on 2020/7/29.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//    var button = UIButton(frame: )
    var button = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        button.setTitle("登录", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 45)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 15
        self.view.addSubview(button)
    }
    
    

}

