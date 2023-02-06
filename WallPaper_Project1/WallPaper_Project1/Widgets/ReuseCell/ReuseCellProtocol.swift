//
//  ReuseCell.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 11/01/2023.
//

import Foundation

protocol ReuseCellType: AnyObject {
    static var defaultReuseIdentifier: String { get }
    static var nibName: String { get }
}
