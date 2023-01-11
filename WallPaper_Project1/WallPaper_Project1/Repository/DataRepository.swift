//
//  PhotoRepository.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 07/01/2023.
//

import Foundation

struct DataRepository: APIRespository {

    private let apiCaller = APICaller.shared

    func getImagesCurated(completion: @escaping ([Image]?, Error?) -> Void) {
        apiCaller.getJSON(urlApi: "\(BaseUrl.photo.rawValue)\(EndpointAPI.curatedPhoto.rawValue)" ) {(data: Images?, error) in
            if let data = data {
                completion(data.photos, error)
            }
        }
    }

    func getImagesByName(name: String, completion: @escaping ([Image]?, Error?) -> Void) {
        apiCaller.getJSON(urlApi: "\(BaseUrl.photo.rawValue)\(EndpointAPI.search.rawValue)\(name)" ) { (data: Images?, error) in
            if let data = data {
                completion(data.photos, error)
            }
        }
    }

    func getVideosByName(name: String, completion: @escaping ([Video]?, Error?) -> Void) {
        apiCaller.getJSON(urlApi: "\(BaseUrl.video.rawValue)\(EndpointAPI.search.rawValue)\(name)") { (data: Videos?, error) in
            if let data = data {
                completion(data.videos, error)
            }
        }
    }
}
