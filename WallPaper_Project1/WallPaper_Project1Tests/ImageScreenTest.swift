//
//  ImageScreenTest.swift
//  WallPaper_Project1Tests
//
//  Created by DuyThai on 08/02/2023.
//

import XCTest
@testable import WallPaper_Project1

final class ImageScreenTest: XCTestCase {
    var sut: ImageViewController!
    
    override func setUpWithError() throws {
        sut = ImageViewController()
        sut.loadViewIfNeeded()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func testExample() throws {
        let imgTest =  Image(id: 15465414,
                             width: 3042,
                             height: 4096,
                             url: "https://www.pexels.com/photo/man-people-street-wall-15465414/",
                             photographer: "The Earthy Jay",
                             photographerUrl: "https://www.pexels.com/@the-earthy-jay-380084919",
                             photographerId: 380084919,
                             avgColor: "#585F58",
                             source: WallPaper_Project1.Source(
                                original: "https://images.pexels.com/photos/15465414/pexels-photo-15465414.jpeg",
                                large2x: "https://images.pexels.com/photos/15465414/pexels-photo-15465414.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
                                large: "https://images.pexels.com/photos/15465414/pexels-photo-15465414.jpeg?auto=compress&cs=tinysrgb&h=650&w=940",
                                medium: "https://images.pexels.com/photos/15465414/pexels-photo-15465414.jpeg?auto=compress&cs=tinysrgb&h=350",
                                small: "https://images.pexels.com/photos/15465414/pexels-photo-15465414.jpeg?auto=compress&cs=tinysrgb&h=130",
                                portrait: "https://images.pexels.com/photos/15465414/pexels-photo-15465414.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800",
                                landscape: "https://images.pexels.com/photos/15465414/pexels-photo-15465414.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200",
                                tiny: "https://images.pexels.com/photos/15465414/pexels-photo-15465414.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280"),
                             liked: false,
                             alt: "")
        let imgsTest = Images(page: 1, perPage: 2, photos: [imgTest], totalResults: 2222, nextPage: "https://api.pexels.com/v1/curated/?page=2&per_page=15")
        sut.viewDidLoad()
        sut.checkNetworkConnection()
        sut.viewDidAppear(true)
        sut.getImageCurated()
        sut.loadMore(url: "https://api.pexels.com/v1/curated/?page=2&per_page=15")
        sut.switchCategory(category: "animal")
        sut.switchCategory(category: "car")
        sut.switchCategory(category: "curated")
        sut.switchCategory(category: "nature")
        sut.switchCategory(category: "robot")
        sut.switchCategory(category: "sea")
        sut.getImagesByName(name: "sky")
        sut.getImagesNextPage(url: "https://api.pexels.com/v1/curated/?page=2&per_page=15")
        sut.getImageData(data: imgsTest, error: nil)
        sut.refreshData(UIView())
        sut.showPopUp(notice: "test")
        sut.collectionView(sut.categoryCollectionView, didSelectItemAt: IndexPath(item: 1, section: 1))
        XCTAssertNotNil(sut.collectionView(sut.categoryCollectionView, cellForItemAt: IndexPath(item: 1, section: 2)))
    }
    
    func testGetListImageFailed() {
        sut.dataRepository.getImagesInNextPage(url: "wrong_url") { (data, error) in
            XCTAssert(error != nil)
            XCTAssert(data == nil)
        }
    }
    
    func testGetListImageSuccess() {
        sut.dataRepository.getImagesInNextPage(url: "https://api.pexels.com/v1/curated/?page=2&per_page=15") { (data, error) in
            XCTAssert(error == nil)
            XCTAssert(data != nil)
        }
    }
    
}
