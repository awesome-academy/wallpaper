//
//  PhotoRepository.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 07/01/2023.
//

import Foundation

struct DataRepository: APIRespository {

    private let apiCaller = APICaller.shared

    func getImagesInNextPage(url: String, completion: @escaping (Images?, Error?) -> Void) {
        apiCaller.getJSON(urlApi: url) {(data: Images?, error) in
            if let data = data {
                completion(data, error)
            }
        }
    }

    func getImagesCurated(completion: @escaping (Images?, Error?) -> Void) {
        apiCaller.getJSON(
            urlApi: "\(BaseUrl.photo.rawValue)\(EndpointAPI.curatedPhoto.rawValue)" ) {(data: Images?, error) in
            if let data = data {
                completion(data, error)
            }
        }
    }

    func getImagesByName(name: String, completion: @escaping (Images?, Error?) -> Void) {
        apiCaller.getJSON(
            urlApi: "\(BaseUrl.photo.rawValue)\(EndpointAPI.search.rawValue)\(name)" ) { (data: Images?, error) in
            if let data = data {
                completion(data, error)
            }
        }
    }

    func getVideosByName(name: String, completion: @escaping (Videos?, Error?) -> Void) {
        apiCaller.getJSON(
            urlApi: "\(BaseUrl.video.rawValue)\(EndpointAPI.search.rawValue)\(name)") { (data: Videos?, error) in
            if let data = data {
                completion(data, error)
            }
        }
    }
}
