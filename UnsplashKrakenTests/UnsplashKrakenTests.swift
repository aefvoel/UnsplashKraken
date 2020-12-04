//
//  UnsplashKrakenTests.swift
//  UnsplashKrakenTests
//
//  Created by Toriq Wahid Syaefullah on 01/12/20.
//

import XCTest
@testable import UnsplashKraken

class UnsplashKrakenTests: XCTestCase {

    private var param = Parameter()
    func testQueryParameter(){
        XCTAssertEqual(param.query, "office")
        param.query = "beach"
        XCTAssertEqual(param.query, "beach")
    }
    func testPageParameter(){
        XCTAssertEqual(param.page, "1")
        param.page = "2"
        XCTAssertEqual(param.page, "2")
    }
}
