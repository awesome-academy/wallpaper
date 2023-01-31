//
//  PhotoRepository.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 07/01/2023.
//

import Foundation

struct DataRepository: APIRespositoryType {

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
            urlApi: "\(BaseUrl.baseUrl.rawValue)\(EndpointAPI.curatedPhoto.rawValue)" ) {(data: Images?, error) in
                if let data = data {
                    completion(data, error)
                }
            }
    }

    func getImagesByName(name: String, completion: @escaping (Images?, Error?) -> Void) {
        apiCaller.getJSON(
            urlApi: "\(BaseUrl.baseUrl.rawValue)\(EndpointAPI.searchPhoto.rawValue)\(name)" ) { (data: Images?, error) in
                if let data = data {
                    completion(data, error)
                }
            }
    }

    func getVideosByName(name: String, completion: @escaping (Videos?, Error?) -> Void) {
        apiCaller.getJSON(
            urlApi: "\(BaseUrl.baseUrl.rawValue)\(EndpointAPI.searchVideo.rawValue)\(name)") { (data: Videos?, error) in
                if let data = data {
                    completion(data, error)
                }
            }
    }

    func getVideosPopular(completion: @escaping (Videos?, Error?) -> Void) {
        apiCaller.getJSON(
            urlApi: "\(BaseUrl.baseUrl.rawValue)\(EndpointAPI.popularVideo.rawValue)") { (data: Videos?, error) in
                if let data = data {
                    completion(data, error)
                }
            }
    }

    func getVideosNextPage(nextUrl: String, completion: @escaping (Videos?, Error?) -> Void) {
        apiCaller.getJSON(urlApi: nextUrl) { (data: Videos?, error) in
            if let data = data {
                completion(data, error)
            }
        }
    }

    func getDataByPage<T: Codable>(url: String, completion: @escaping (T?, Error?) -> Void) {
        apiCaller.getJSON(urlApi: url) {(data: T?, error) in
            if let data = data {
                completion(data, error)
            }
        }
    }

}
