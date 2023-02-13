//
//  WaitingLoadingViewControllerTest.swift
//  WallPaper_Project1Tests
//
//  Created by DuyThai on 15/02/2023.
//

import XCTest
@testable import WallPaper_Project1

final class WaitingLoadingViewControllerTest: XCTestCase {
    var sut: WaitingLoadingViewController!

    override func setUpWithError() throws {
        sut = WaitingLoadingViewController()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func testExample() throws {
        sut.viewDidLoad()
        sut.viewWillDisappear(true)
        sut.configView()
        sut.updateView(status: true)
        sut.updateView(status: false)
    }

}
