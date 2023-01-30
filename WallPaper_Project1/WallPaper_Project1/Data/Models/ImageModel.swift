//
//  ImageModel.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 06/01/2023.
//

import Foundation

struct Image: Codable {
    let id: Int
    let width: Int
    let height: Int
    let url: String
    let photographer: String
    let photographerUrl: String
    let photographerId: Int
    let avgColor: String
    let source: Source
    let liked: Bool
    let alt: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case width = "width"
        case height = "height"
        case url = "url"
        case photographer = "photographer"
        case photographerUrl = "photographer_url"
        case photographerId = "photographer_id"
        case avgColor = "avg_color"
        case source = "src"
        case liked = "liked"
        case alt = "alt"
    }
}

struct Source: Codable {
    let original: String
    let large2x: String
    let large: String
    let medium: String
    let small: String
    let portrait: String
    let landscape: String
    let tiny: String
}

struct Images: Codable {
    let page: Int
    let perPage: Int
    let photos: [Image]?
    let totalResults: Int
    let nextPage: String?
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case perPage = "per_page"
        case photos = "photos"
        case totalResults = "total_results"
        case nextPage = "next_page"
    }
}
