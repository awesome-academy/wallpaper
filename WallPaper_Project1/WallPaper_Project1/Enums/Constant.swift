//
//  Constant.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 06/01/2023.
//

import Foundation


enum BaseUrl: String {
    case photo = "https://api.pexels.com/v1/"
    case video = "https://api.pexels.com/videos"
}

enum EndpointAPI: String {
    case search = "search?query="
    case curatedPhoto = "curated"
    case popularVideo = "popular"
}
