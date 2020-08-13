//
//  WSBURL.swift
//  WSBoyChat
//
//  Created by hezhichang on 2020/8/6.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import Foundation

struct WSBURL {
    fileprivate static let scheme: String = "http"
    fileprivate static let host = "49.232.19.17"
    fileprivate static let registerPath: String = "/api/v1/user/register"
    fileprivate static let loginPath: String = "/api/v1/user/login"
    
    static var registerURL: String {
        return scheme + "://" + host + registerPath
    }
    
    static var loginURL: String {
        return scheme + "://" + host + loginPath
    }
}
