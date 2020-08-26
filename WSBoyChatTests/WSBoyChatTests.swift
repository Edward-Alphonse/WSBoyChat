//
//  WSBoyChatTests.swift
//  WSBoyChatTests
//
//  Created by zhichang.he on 2020/7/29.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import XCTest
@testable import WSBoyChat

class WSBoyChatTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func convertIP() {
        _ = WSBLoginService.shared.converIPToUInt32(a: 192, b: 168, c: 1, d: 8)
        _ = FSSocketNetwork.shared.convert(ip: "192.168.1.8")
    }
    
    func testBigEndianToLittleEndian() {
        print("--------\(CFSwapInt16HostToBig(21567))")
        print("--------\(UInt16(littleEndian: 21567))")
        print("--------\(UInt16(bigEndian: 21567))")
    }
    
    func testFSSocketNetwork() {
        FSSocketNetwork.shared.host = "192.168.1.8"
        FSSocketNetwork.shared.port = "21567"
        FSSocketNetwork.shared.setupConnection()
//        FSSocketNetwork.shared.sendTCP()
//        FSSocketNetwork.shared.recvTCP()
        FSSocketNetwork.shared.closeConnection()
    }

}
