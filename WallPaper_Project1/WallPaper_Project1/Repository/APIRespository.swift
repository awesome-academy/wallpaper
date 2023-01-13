//
//  APIRespository.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 06/01/2023.
//

import Foundation

protocol APIRespository {

    func getImagesByName(name: String, completion: @escaping (Images?, Error?) -> Void)

    func getImagesInNextPage(url: String, completion: @escaping (Images?, Error?) -> Void)

    func getImagesCurated(completion: @escaping (Images?, Error?) -> Void)

    func getVideosByName(name: String, completion: @escaping (Videos?, Error?) -> Void)
}
