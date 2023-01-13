//
//  Others.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 09/01/2023.
//

import Foundation

enum ItemTabBar: Int {
    case photoScreen = 0
    case livePhotoScreen = 1
    case searchScreen = 2
    case personalScreen = 3

    func getTitle() -> String {
        switch self {
        case .photoScreen:
            return "Photo"
        case .livePhotoScreen:
            return "Live Photo"
        case .searchScreen:
            return "Search"
        case .personalScreen:
            return "Personal"
        }
    }
    func getIconName() -> String {
        switch self {
        case .photoScreen:
            return "photo.on.rectangle.angled"
        case .livePhotoScreen:
            return "livephoto"
        case .searchScreen:
            return "magnifyingglass"
        case .personalScreen:
            return "person.fill"
        }
    }
}

enum Category: String {
    case curated = "Currated"
    case nature = "Nature"
    case sea = "Sea"
    case sky = "Sky"
    case animal = "Animal"
    case car = "Car"
    case robot = "Robot"
}
