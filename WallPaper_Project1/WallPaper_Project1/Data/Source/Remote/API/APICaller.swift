//
//  APICaller.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 06/01/2023.
//

import Foundation

class APICaller {
    static let shared = APICaller()
    private let session: URLSession
    private var imagesCache = NSCache<NSString, NSData>()

    private init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    let headers = [
        "Authorization": GetDataFromPlist.getStringValue(forKey: "Api_Key")
    ]

    func getJSON<T: Codable>(urlApi: String, completion: @escaping (T?, Error?) -> Void) {
        guard let url = URL(string: urlApi) else {
            return
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = MethodRequest.get.rawValue
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {return}
            let task = self.session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                if let error = error {
                    completion(nil, error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(nil, NetworkError.badResponse)
                    return
                }
                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(nil, NetworkError.badStatusCode(httpResponse.statusCode))
                    return
                }
                guard let data = data else {
                    completion(nil, NetworkError.badData)
                    return
                }
                do {
                    let results = try JSONDecoder().decode(T.self, from: data)
                    completion(results, nil)
                } catch let error {
                    completion(nil, error)
                }
            }
            task.resume()
        }
    }

    func getImage(imageURL: String, completion: @escaping (Data?, Error?) -> Void) {
        if let imageData = imagesCache.object(forKey: imageURL as NSString) {
            completion(imageData as Data, nil)
            return
        }
        guard let url = URL(string: imageURL) else {
            completion(nil, NetworkError.badData)
            return
        }
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {return}
            let task = self.session.downloadTask(with: url) { (localUrl: URL?, response: URLResponse?, error: Error?) in
                if let error = error {
                    completion(nil, error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(nil, NetworkError.badResponse)
                    return
                }
                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(nil, NetworkError.badStatusCode(httpResponse.statusCode))
                    return
                }
                guard let localUrl = localUrl else {
                    completion(nil, NetworkError.badData)
                    return
                }
                do {
                    let data = try Data(contentsOf: localUrl)
                    self.imagesCache.setObject(data as NSData, forKey: imageURL as NSString)
                    completion(data, nil)
                } catch let error {
                    completion(nil, error)
                }
            }
            task.resume()
        }
    }
}
