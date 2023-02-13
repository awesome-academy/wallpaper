//
//  SearchScreenTest.swift
//  WallPaper_Project1Tests
//
//  Created by DuyThai on 13/02/2023.
//

import XCTest
@testable import WallPaper_Project1

final class SearchScreenTest: XCTestCase {
    var sut: SearchViewController!

    override func setUpWithError() throws {
        sut = SearchViewController()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func testExample() throws {
        sut.viewDidLoad()
        sut.congfigSearchBarView()
        sut.viewDidAppear(true)
        sut.numberPageTapped(UIView())
        sut.viewDidAppear(true)
        sut.getImagesByPage(numberPage: "1", querry: "sea")
        sut.getVideosByPage(numberPage: "1", querry: "sky")
        sut.congfigSearchBarView()
        sut.configPageView()
        sut.configCollectionView()
        sut.getVideosByName(name: "cat")
        sut.showCollectionView()
        sut.showPopUp(notice: "Test")
        sut.pageIsSelected(numberPage: "1")
        sut.getImagesByPage(numberPage: "1", querry: "sea")
        sut.pagePositionContainerView1(UITapGestureRecognizer())
        sut.pagePositionContainerView2(UITapGestureRecognizer())
        sut.pagePositionContainerView3(UITapGestureRecognizer())
        sut.pagePositionContainerView4(UITapGestureRecognizer())
        sut.pagePositionContainerView5(UITapGestureRecognizer())
        sut.previousPageTapped(UIImage())
        sut.nextPageTapped(UIImage())
        sut.getData(data: Image.self, error: nil)
        sut.setPage()
        sut.searchBarSearchButtonClicked(sut.searchBar)
        sut.searchBarBookmarkButtonClicked(sut.searchBar)
    }

    func getLisImageSuccessed() throws {
        sut.dataRepository.getImagesByName(name: "sea") { (data, error) in
            XCTAssert(error == nil)
            XCTAssert(data != nil)
        }
    }

    func getLisImageFailed() throws {
        sut.dataRepository.getImagesByName(name: "âssdasdea") { (data, error) in
            XCTAssert(error != nil)
            XCTAssert(data == nil)
        }
    }

}
