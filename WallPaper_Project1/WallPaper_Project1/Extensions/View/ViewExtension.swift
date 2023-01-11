//
//  ViewExtension.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 10/01/2023.
//

import Foundation
import UIKit

extension UIView {
    func circleView() {
        layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
