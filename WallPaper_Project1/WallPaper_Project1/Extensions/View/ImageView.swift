//
//  ImageView.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 11/01/2023.
//

import Foundation
import UIKit

extension UIImageView {

    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }

}
