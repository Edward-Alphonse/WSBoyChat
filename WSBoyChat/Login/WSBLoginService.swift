//
//  WSBLoginService.swift
//  WSBoyChat
//
//  Created by hezhichang on 2020/8/6.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import Foundation

typealias WSBLoginHandler = (Data?, URLResponse?, Error?) -> Void

class WSBLoginService {
    static let shared = WSBLoginService()
    
    func register(_ parameters: [String: Any], _ completionHandler: @escaping WSBLoginHandler) {
        guard let url = URL(string: WSBURL.registerURL) else {
            return
        }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            completionHandler(data, response, error)
        }
        task.resume()
    }
    
    func login(_ parameters: [String: Any], _ completionHandler: @escaping WSBLoginHandler) {
        guard var components = URLComponents(string: WSBURL.loginURL) else {
            return
        }
        components.queryItems = parameters.map({ (key, value) in
            return URLQueryItem(name: key, value: "\(value)")
        })
        guard let url = components.url else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            completionHandler(data, response, error)
        }
        
        task.resume()
    }
}
