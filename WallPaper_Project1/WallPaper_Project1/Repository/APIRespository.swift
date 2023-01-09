//
//  APIRespository.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 06/01/2023.
//

import Foundation

protocol APIRespository {
    associatedtype IMAGE
    associatedtype VIDEO

    func getImagesByName(name: String, completion: @escaping ([IMAGE]?, Error?) -> Void)
    func getVideosByName(name: String, completion: @escaping ([VIDEO]?, Error?) -> Void)
}
