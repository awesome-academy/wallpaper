//
//  DetailScreenTest.swift
//  WallPaper_Project1Tests
//
//  Created by DuyThai on 08/02/2023.
//

import XCTest
@testable import WallPaper_Project1

final class DetailScreenTest: XCTestCase {
    var sut: DetailViewController!
    let image = Image(id: 15464741,
                      width: 3024,
                      height: 4032,
                      url: "https://www.pexels.com/photo/bread-food-plate-restaurant-15464741/",
                      photographer: "Yelena Odintsova",
                      photographerUrl: "https://www.pexels.com/@yelenaodintsova",
                      photographerId: 3068556,
                      avgColor: "#A49F99",
                      source: WallPaper_Project1.Source(
                        original: "https://images.pexels.com/photos/15464741/pexels-photo-15464741.jpeg",
                        large2x: "https://images.pexels.com/photos/15464741/pexels-photo-15464741.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
                        large: "https://images.pexels.com/photos/15464741/pexels-photo-15464741.jpeg?auto=compress&cs=tinysrgb&h=650&w=940",
                        medium: "https://images.pexels.com/photos/15464741/pexels-photo-15464741.jpeg?auto=compress&cs=tinysrgb&h=350",
                        small: "https://images.pexels.com/photos/15464741/pexels-photo-15464741.jpeg?auto=compress&cs=tinysrgb&h=130",
                        portrait: "https://images.pexels.com/photos/15464741/pexels-photo-15464741.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800",
                        landscape: "https://images.pexels.com/photos/15464741/pexels-photo-15464741.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200",
                        tiny: "https://images.pexels.com/photos/15464741/pexels-photo-15464741.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280"),
                      liked: false,
                      alt: "")

    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DetailViewController()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func testExample() throws {
        sut.loadViewIfNeeded()
        sut.viewDidLoad()
        sut.viewWillAppear(true)
        sut.viewWillDisappear(true)
        sut.viewDidDisappear(true)
        sut.configView()
        sut.saveToCoreData(entityName: "DownloadData")
        sut.checkIsFavorited()
        sut.downloadButton.sendActions(for: .touchUpInside)
        sut.favoriteButton.sendActions(for: .touchUpInside)
        sut.longPressCell(UITapGestureRecognizer())
        sut.authorLabelTapped(UILabel())
        sut.downloadButtonTapped(UIButton())
        sut.favoriteButtonTapped(UIButton())
        sut.updateImageView(image: image)
        sut.infomationButtonTapped(UIImage())
        sut.backButtonTapped(UIButton())
        sut.showPopUp(notice: "test")
        testUpdateView()
        XCTAssertNotNil(sut.authorNameLabel?.text)
        XCTAssertNotNil(sut.colorImageLabel?.text)
        XCTAssertNotNil(sut.imageIdLabel?.text)
        XCTAssertNotNil(sut.heightImageLabel?.text)
        XCTAssertNotNil(sut.widthImageLabel?.text)
        sut.topButtonViewContainer.backgroundColor = .init(hexString: "#FFFFFF", alpha: 0.2)

    }

    func testUpdateView() {
        XCTAssertNotNil(sut.imageToMedia(image: image))
        sut.bindDataImage(image: image)
        sut.updateImageView(image: image)
        XCTAssertNotNil(sut.videoToMedia(video: Video(id: 12312,
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
                                                       Picture(id: 12, picture: "LinkPicture")])))
        sut.bindDataVideo(video: Video(id: 12312,
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
                                        Picture(id: 12, picture: "LinkPicture")]))
        XCTAssertEqual(sut.id, 12312)
        sut.updateVideoView()
        sut.updateInformationVideo(video: Video(id: 12312,
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
                                                 Picture(id: 12, picture: "LinkPicture")]))
        sut.informationFromCoreData(data: Media(id: 1,
                                                width: 1313,
                                                height: 12121,
                                                url: "url",
                                                photographer: "namePg",
                                                photographerId: 1,
                                                photographerUrl: "link",
                                                avgColor: "#1212",
                                                isVideo: 0,
                                                videoDuration: 12))
        sut.bindDataFromCoreData(data: Media(id: 123,
                                             width: 1341,
                                             height: 1231,
                                             url: "url",
                                             photographer: "Photographer",
                                             photographerId: 99,
                                             photographerUrl: "Photographer_url",
                                             avgColor: "#32323",
                                             isVideo: 1231,
                                             videoDuration: 22))
        XCTAssertEqual(sut.id, 123)
        sut.informationFromCoreData(data: Media(id: 123,
                                                width: 1341,
                                                height: 1231,
                                                url: "url",
                                                photographer: "Photographer",
                                                photographerId: 99,
                                                photographerUrl: "Photographer_url",
                                                avgColor: "#32323",
                                                isVideo: 1231,
                                                videoDuration: 22))
    }
    
    func testGetDetail() throws {
        let image = Image(id: 15464741,
                          width: 3024,
                          height: 4032,
                          url: "https://www.pexels.com/photo/bread-food-plate-restaurant-15464741/",
                          photographer: "Yelena Odintsova",
                          photographerUrl: "https://www.pexels.com/@yelenaodintsova",
                          photographerId: 3068556,
                          avgColor: "#A49F99",
                          source: WallPaper_Project1.Source(
                            original: "https://images.pexels.com/photos/15464741/pexels-photo-15464741.jpeg",
                            large2x: "https://images.pexels.com/photos/15464741/pexels-photo-15464741.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
                            large: "https://images.pexels.com/photos/15464741/pexels-photo-15464741.jpeg?auto=compress&cs=tinysrgb&h=650&w=940",
                            medium: "https://images.pexels.com/photos/15464741/pexels-photo-15464741.jpeg?auto=compress&cs=tinysrgb&h=350",
                            small: "https://images.pexels.com/photos/15464741/pexels-photo-15464741.jpeg?auto=compress&cs=tinysrgb&h=130",
                            portrait: "https://images.pexels.com/photos/15464741/pexels-photo-15464741.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800",
                            landscape: "https://images.pexels.com/photos/15464741/pexels-photo-15464741.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200",
                            tiny: "https://images.pexels.com/photos/15464741/pexels-photo-15464741.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280"),
                          liked: false,
                          alt: "")
        XCTAssertNotNil(sut.imageToMedia(image: image))
    }
    
    func saveToCoreDataTest() throws {
        sut.saveToCoreData(entityName: "FavoriteData")
        sut.saveToCoreData(entityName: "DownloadData")
    }

    func testCheckIsFavoritedInCoreDataFailed() throws {
        let check = sut.coreData.checkInCoreData(id: 1, nameEntity: "FavoriteData")
        XCTAssertFalse(check)
    }

    func testCheckIsFavoritedInCoreDataPassed() throws {
        let check = sut.coreData.checkInCoreData(id: 15279711, nameEntity: "FavoriteData")
        XCTAssertTrue(check)
    }
}
