//
//  PersonalScreenTest.swift
//  WallPaper_Project1Tests
//
//  Created by DuyThai on 09/02/2023.
//

import XCTest
@testable import WallPaper_Project1
import CoreData

final class PersonalScreenTest: XCTestCase {
    var sut: PersonalViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = PersonalViewController()
        sut.loadViewIfNeeded()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func testExample() throws {
        sut.viewDidLoad()
        sut.viewWillAppear(true)
        sut.viewDidAppear(true)
        sut.viewDidLayoutSubviews()
        sut.update()
        sut.checkNetworkConnection()
        sut.updateNumberFavoriteAndDownload()
        sut.configRefesh()
        sut.refreshData(UIButton())
        sut.getDataFromCoreData()
        sut.configView()
        sut.configCollectionView()
        sut.showPopUp(notice: "test")
        sut.coreData.getDataFromCoreData(nameEntity: "DownloadData") { [unowned self] items, error in
            guard error == nil else {
                sut.showPopUp(notice: "Could not fetch. \(String(describing: error))")
                return
            }
            sut.dataDownloadFromCoreData = items.map {
                sut.changeNSManagedObjectToMedia(nsManagedObject: $0)
            }
            sut.downloadButtonTapped(UIButton())
            sut.favoriteButtonTapped(UIButton())
            sut.update()
            sut.refreshData(UIView())
            sut.collectionView(sut.collectionView, didSelectItemAt: IndexPath(item: 1, section: 1))
            sut.collectionView(sut.collectionView, cellForItemAt: IndexPath(item: 1, section: 1))
        }
        sut.downloadButtonTapped(UIButton())
        sut.favoriteButtonTapped(UIButton())
        sut.collectionView(sut.collectionView, didSelectItemAt: IndexPath(item: 1, section: 1))
        XCTAssertNotNil(sut.collectionView(sut.collectionView, cellForItemAt: IndexPath(item: 1, section: 2)))
    }
    
    func testGetDataFromCoreData() throws {
        let coreData = LocalData.shared
        coreData.getDataFromCoreData(nameEntity: "DownloadData") { items, error in
           XCTAssert(error == nil)
            XCTAssertNotEqual(items.count, 0)
        }
    }
}
