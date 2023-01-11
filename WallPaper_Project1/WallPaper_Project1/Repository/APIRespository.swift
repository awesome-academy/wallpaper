//
//  APIRespository.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 06/01/2023.
//

import Foundation

protocol APIRespository {

    func getImagesByName(name: String, completion: @escaping ([Image]?, Error?) -> Void)

    func getImagesCurated(completion: @escaping ([Image]?, Error?) -> Void)

    func getVideosByName(name: String, completion: @escaping ([Video]?, Error?) -> Void)
}
