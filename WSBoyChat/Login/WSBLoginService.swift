//
//  WSBLoginService.swift
//  WSBoyChat
//
//  Created by hezhichang on 2020/8/6.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import Foundation
import Darwin

typealias WSBLoginHandler = ((Data?, URLResponse?, Error?) -> Void)

class WSBLoginService {
    static let shared = WSBLoginService()
    
    static func performActionAfterLogin(_ parameters: [String: Any], action: ((Bool) -> Void)) {
        
    }
    
    
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
    
    func converIPToUInt32(a: Int, b: Int, c: Int, d: Int) -> in_addr {
        let value = (a << 0) | (b << 8) | (c << 16) | (d << 24)
        let addr = in_addr_t(value)
        return Darwin.in_addr(s_addr: addr)
    }
    
    func client() {
        let socketFD = socket(AF_INET, SOCK_STREAM, 0)
        var sock4: sockaddr_in = sockaddr_in()
        sock4.sin_len = __uint8_t(MemoryLayout.size(ofValue: sock4))
        // 将ip转换成UInt32
        sock4.sin_addr = converIPToUInt32(a: 192, b: 168, c: 1, d: 8)
        // 因内存字节和网络通讯字节相反，顾我们需要交换大小端，我们连接的端口是9090
//        sock4.sin_port = CFSwapInt16HostToBig(21567)
        sock4.sin_port = UInt16(bigEndian: 21567)
        // 设置sin_family 为 AF_INET表示着这个为IPv4 连接
        sock4.sin_family = sa_family_t(AF_INET)
        // Swift 中指针强转比OC要复杂
        let pointer: UnsafePointer<sockaddr> = withUnsafePointer(to: &sock4, {$0.withMemoryRebound(to: sockaddr.self, capacity: 1, {$0})})

        let result = connect(socketFD, pointer, socklen_t(MemoryLayout.size(ofValue: sock4)))
        guard result != -1 else {
            fatalError("Error in connect() function code is \(errno)")
        }
        
//        while true {
            let data = " 你好，我是阿帕奇: https://juejin.im/post/6844903765590409229".data(using: .utf8) ?? Data()
            // 我们将data转为rawPointer指针 也就是c语言中的 (void *) 指针
            let rawPointer = data.withUnsafeBytes({UnsafeRawPointer($0)})
            // 我们需要提供指针(数据的首地址) 和 数据的长度给函数
            var resultWrite = Darwin.write(socketFD, rawPointer, data.count)

            guard resultWrite != -1 else {
                fatalError("Error in write() function code is \(errno)")
//                break
            }
            
            // 初始化数据接收区
            let readData = Data(count: 500)
            // 我们将data转为rawPointer指针
            let readRawPointer = readData.withUnsafeBytes({UnsafeMutableRawPointer(mutating: $0)})
            // 最后的长度为 缓存区的长度
            let resultRead = Darwin.read(socketFD, readRawPointer, readData.count)
            // 打印socket的返回值
            print("\(String(data: readData, encoding: .utf8) ?? "")")

//        }
        close(socketFD)
    }
}

public class WSBNetworkManager {
    public static let shared = WSBNetworkManager()
    private init() {}
    
    func connect(host: String, port: String) {
        FSSocketNetwork.shared.setupConnection(host: host, port: port)
    }
    
    func send(string: String, receive block: ((Data) -> Void)? = nil ) {
        guard let sendData = string.data(using: .utf8) else {
            return
        }
        FSSocketNetwork.shared.send(data: sendData)
        let recvData = FSSocketNetwork.shared.receive()
        block?(recvData)
    }

    func close() {
        FSSocketNetwork.shared.closeConnection()
    }
}

public class FSSocketNetwork {
    static let shared = FSSocketNetwork()
    fileprivate var host: String = ""
    fileprivate var port: String = ""
    fileprivate var socketFD: Int32?
    
    public init() {}
    
    fileprivate func convert(ip ipStr: String) -> in_addr? {
        let list = ipStr.split(separator: ".")
            .map { Int(String($0))}
            .filter { $0 != nil }
            .map { $0! }
        
        guard list.count == 4 else {
            return nil
        }
        let value = (list[0] << 0) | (list[1] << 8) | (list[2] << 16) | (list[3] << 24)
        let addr = in_addr_t(value)
        return Darwin.in_addr(s_addr: addr)
    }
    
    func setupConnection(host: String, port: String) {
        self.host = host
        self.port = port
        setupConnection()
    }
    
    func setupConnection() {
        guard let sin_addr = convert(ip: host) else {
            fatalError("illegal host")
        }
        guard let port = UInt16(String(port)) else {
            fatalError("illegal port")
        }
        
        let socketFD = socket(AF_INET, SOCK_STREAM, 0)
        var sock4: sockaddr_in = sockaddr_in()
        sock4.sin_len = __uint8_t(MemoryLayout.size(ofValue: sock4))
        sock4.sin_addr = sin_addr
        // 因内存字节和网络通讯字节相反，故需要交换大小端
        // sock4.sin_port = CFSwapInt16HostToBig(21567)
        sock4.sin_port = UInt16(bigEndian: port)
        // 设置sin_family 为 AF_INET表示着这个为IPv4 连接
        sock4.sin_family = sa_family_t(AF_INET)
        // Swift 中指针强转比OC要复杂
        let pointer: UnsafePointer<sockaddr> = withUnsafePointer(to: &sock4, {$0.withMemoryRebound(to: sockaddr.self, capacity: 1, {$0})})
        let result = connect(socketFD, pointer, socklen_t(MemoryLayout.size(ofValue: sock4)))
        guard result != -1 else {
//            fatalError("Error in connect() function code is \(errno)")
            return
        }
        self.socketFD = socketFD
    }
    
    func closeConnection() {
        guard let socketFD = socketFD else {
            fatalError("socketFD is nil")
        }
        close(socketFD)
    }
    
    func send(data: Data) {
        guard let socketFD = socketFD else {
            fatalError("socketFD is nil")
        }
        // 我们将data转为rawPointer指针 也就是c语言中的 (void *) 指针
        let rawPointer = data.withUnsafeBytes({UnsafeRawPointer($0)})
        let resultWrite = Darwin.write(socketFD, rawPointer, data.count)
        guard resultWrite != -1 else {
            fatalError("Error in write() function code is \(errno)")
        }
    }
    
    func receive() -> Data {
        guard let socketFD = socketFD else {
            fatalError("socketFD is nil")
        }
        // 初始化数据接收区
        let readData = Data(count: 500)
        // 我们将data转为rawPointer指针
        let readRawPointer = readData.withUnsafeBytes({UnsafeMutableRawPointer(mutating: $0)})
        // 最后的长度为 缓存区的长度
        let resultRead = Darwin.read(socketFD, readRawPointer, readData.count)
        
        guard resultRead != -1 else {
            fatalError("Error in read() function code is \(errno)")
        }
        return readData
    }
}
