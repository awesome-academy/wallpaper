//
//  VideoModel.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 06/01/2023.
//

import Foundation

struct Videos: Codable {
    let page: Int
    let perPage: Int
    let totalResults: Int
    let url: String
    let videos: [Video]?
    let nextPage: String

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case perPage = "per_page"
        case totalResults = "total_results"
        case url = "url"
        case videos = "videos"
        case nextPage = "next_page"
    }
}

struct Video: Codable {
    let id: Int
    let width: Int
    let height: Int
    let url: String
    let duration: Int
    let image: String
    let avgColor: String?
    let user: User
    let videoFiles: [DetailVideo]?
    let videoPictures: [Picture]

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case width = "width"
        case height = "height"
        case url = "url"
        case duration = "duration"
        case image = "image"
        case avgColor = "avg_color"
        case user = "user"
        case videoFiles = "video_files"
        case videoPictures = "video_pictures"
    }
}

struct User: Codable {
    let id: Int
    let name: String
    let url: String
}

struct DetailVideo: Codable {
    let id: Int
    let quality: String
    let fileType: String
    let width: Int
    let height: Int
    let fps: Double?
    let link: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case quality = "quality"
        case fileType = "file_type"
        case width = "width"
        case height = "height"
        case fps = "fps"
        case link = "link"
    }
}

struct Picture: Codable {
    let id: Int
    let picture: String
}
