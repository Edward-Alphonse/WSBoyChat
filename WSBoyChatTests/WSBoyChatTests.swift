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
        WSBLoginService.shared.login(["username": "hzc", "password": "hzc"])
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

}
