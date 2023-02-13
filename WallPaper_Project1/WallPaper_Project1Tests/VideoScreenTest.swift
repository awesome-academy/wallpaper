//
//  VideoScreenTest.swift
//  WallPaper_Project1Tests
//
//  Created by DuyThai on 09/02/2023.
//

import XCTest
@testable import WallPaper_Project1

final class VideoScreenTest: XCTestCase {
    var sut: VideoScreenViewController!
    let videoFakeData = [
        Video(id: 12312,
              width: 999,
              height: 666,
              url: "video_url",
              duration: 12,
              image: "url",
              avgColor: "#66677",
              user: User(id: 12,
                         name: "NameUSer", url: "user_url"),
              videoFiles: [
                DetailVideo(id: 323,
                            quality: "hd",
                            fileType: ".mp4",
                            width: 1080,
                            height: 2220,
                            fps: 60.0,
                            link: "Link file media")
              ],
              videoPictures: [
                Picture(id: 12, picture: "LinkPicture")])
    ]
    
    override func setUpWithError() throws {
        sut = VideoScreenViewController()
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
        sut.configRefesh()
        sut.refreshData(UIButton())
        sut.checkNetworkConnection()
        sut.configVideoView()
        sut.switchCategory(category: "animal")
        sut.switchCategory(category: "car")
        sut.switchCategory(category: "popular")
        sut.switchCategory(category: "nature")
        sut.switchCategory(category: "robot")
        sut.switchCategory(category: "sea")
        sut.switchCategory(category: "sky")
        sut.configCategoryView()
        sut.showPopUp(notice: "ssssss")
        sut.getVideosPopular()
        sut.getVideoByName(name: "cat")
        sut.getVideosNextPage(url: "https://api.pexels.com/v1/curated/?page=2&per_page=15")
        sut.loadMore(url: "https://api.pexels.com/v1/curated/?page=2&per_page=15")
        XCTAssertEqual(sut.videoCollectionView.numberOfItems(inSection: 0), sut.videos.count)
        sut.collectionView(sut.categoryCollectionView, didSelectItemAt: IndexPath(item: 1, section: 1))
        let mediaDataTest =  Media(id: 123,
                                   width: 1341,
                                   height: 1231,
                                   url: "url",
                                   photographer: "Photographer",
                                   photographerId: 99,
                                   photographerUrl: "Photographer_url",
                                   avgColor: "#32323",
                                   isVideo: 1231,
                                   videoDuration: 22)
        let detailViewController =  DetailViewController()
        detailViewController.bindDataFromCoreData(data: mediaDataTest)
        detailViewController.bindDataVideo(video: videoFakeData[0])
    }
    
    func testGetList() throws {
        XCTAssertEqual(videoFakeData.count, 1)
        XCTAssertNotNil(sut.collectionView(sut.videoCollectionView, numberOfItemsInSection: 10))
        sut.collectionView(sut.videoCollectionView, willDisplay: VideoCollectionViewCell(), forItemAt: IndexPath(item: 0, section: 0))
        sut.collectionView(sut.videoCollectionView, didEndDisplayingSupplementaryView: LoadCollectionReusableView(),
                           forElementOfKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0))
    }
    
    func testSaveToCoreData() throws {
        let coreData = LocalData.shared
        let mediaDataTest =  Media(id: 123,
                                   width: 1341,
                                   height: 1231,
                                   url: "url",
                                   photographer: "Photographer",
                                   photographerId: 99,
                                   photographerUrl: "Photographer_url",
                                   avgColor: "#32323",
                                   isVideo: 1231,
                                   videoDuration: 22)
        coreData.addToCoreData(data: mediaDataTest, nameEntity: "FavoriteData") { error in
            if let error = error {
                print("Could not save. \(String(describing: error))")
            }
        }
    }
    
}
