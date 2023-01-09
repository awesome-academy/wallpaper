//
//  APIRespository.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 06/01/2023.
//

import Foundation

protocol APIRespository {
    associatedtype I
    associatedtype V
    func getImagesByName(name: String, completion: @escaping ([I]?, Error?) -> Void)
    func getVideosByName(name: String, completion: @escaping ([V]?, Error?) -> Void)
}
