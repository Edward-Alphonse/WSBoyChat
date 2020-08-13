//
//  UIViewController+Router.swift
//  WSBoyChat
//
//  Created by hezhichang on 2020/8/6.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func push(viewController: UIViewController, animated: Bool = true) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        self.navigationController?.popViewController(animated: animated)
    }
}
