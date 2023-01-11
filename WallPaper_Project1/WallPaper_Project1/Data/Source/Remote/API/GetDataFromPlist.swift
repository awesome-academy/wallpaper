//
//  GetDataFromPlist.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 12/01/2023.
//

import Foundation

struct GetDataFromPlist {
    static func getStringValue(forKey key: String) -> String {
        var resourceFileDictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: "Data", ofType: "plist") {
               resourceFileDictionary = NSDictionary(contentsOfFile: path)
           }
        guard let resourceFileDictionaryContent = resourceFileDictionary else {
            fatalError("Could not read Data.plist")
        }
        guard let value = resourceFileDictionaryContent.object(forKey: key) as? String else {
            fatalError("Could not find \(key)")
        }
        return value
    }
}
