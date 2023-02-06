//
//  APIRespository.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 06/01/2023.
//

import Foundation

protocol APIRespositoryType {

    func getImagesByName(name: String, completion: @escaping (Images?, Error?) -> Void)

    func getImagesInNextPage(url: String, completion: @escaping (Images?, Error?) -> Void)

    func getImagesCurated(completion: @escaping (Images?, Error?) -> Void)

    func getVideosByName(name: String, completion: @escaping (Videos?, Error?) -> Void)

    func getVideosPopular(completion: @escaping (Videos?, Error?) -> Void)

    func getVideosNextPage(nextUrl: String, completion: @escaping (Videos?, Error?) -> Void)

    func getDataByPage<T: Codable>(url: String, completion: @escaping (T?, Error?) -> Void)
}
