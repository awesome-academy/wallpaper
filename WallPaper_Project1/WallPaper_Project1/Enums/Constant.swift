//
//  Constant.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 06/01/2023.
//

import Foundation
enum BaseUrl: String {
    case baseUrl = "https://api.pexels.com/"
}

enum EndpointAPI: String {
    case searchPhoto = "v1/search?query="
    case curatedPhoto = "v1/curated"
    case popularVideo = "videos/popular"
    case searchVideo = "videos/v1/search?query="
    case pagePhoto = "v1/search/"
    case pageVideo = "v1/videos/search/"
}
