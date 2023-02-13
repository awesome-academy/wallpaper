//
//  PopUpScreen.swift
//  WallPaper_Project1Tests
//
//  Created by DuyThai on 13/02/2023.
//

import XCTest
@testable import WallPaper_Project1

final class PopUpScreen: XCTestCase {

    var sut: PopUpViewController!

    override func setUpWithError() throws {
        sut = PopUpViewController()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func testExample() throws {
        sut.viewDidLoad()
        sut.viewDidLayoutSubviews()
        sut.viewDidAppear(true)
        sut.closeButtonTapped(UIButton())
    }

}
