//
//  AuthorScreenTest.swift
//  WallPaper_Project1Tests
//
//  Created by DuyThai on 13/02/2023.
//

import XCTest
@testable import WallPaper_Project1

final class AuthorScreenTest: XCTestCase {
    var sut: AuthorViewController!
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = AuthorViewController()
        sut.loadViewIfNeeded()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func testExample() throws {
        sut.viewDidLoad()
        sut.viewWillAppear(true)
        sut.viewDidLayoutSubviews()
    }
    
    func testConfigWebView() throws {
        sut.configWebView(url: "https://www.pexels.com/@yelenaodintsova")
    }
    
}
