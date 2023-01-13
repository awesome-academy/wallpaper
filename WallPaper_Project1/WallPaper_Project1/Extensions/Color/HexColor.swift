//
//  HexColor.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 11/01/2023.
//

import Foundation
import UIKit

extension UIColor {
    static let loadBackgroundColor = UIColor(hexString: "#666666", alpha: 0.8)
    static let seclectedColor = UIColor(#colorLiteral(red: 0.07710499316, green: 0.2985935807, blue: 0.4225793481, alpha: 1))
    static let primaryColor = UIColor(#colorLiteral(red: 0.1254901886, green: 0.1254901886, blue: 0.1254901886, alpha: 1))

    convenience init(hexString: String, alpha: CGFloat) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.currentIndex = scanner.string.index(after: scanner.currentIndex)
        }
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        let mask = 0x000000FF
        let redInt = Int(color >> 16) & mask
        let greenInt = Int(color >> 8) & mask
        let blueInt = Int(color) & mask
        let red = CGFloat(redInt) / 255.0
        let green = CGFloat(greenInt) / 255.0
        let blue = CGFloat(blueInt) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    func toHexString() -> String {
        var redFloat: CGFloat = 0
        var greenFloat: CGFloat = 0
        var blueFloat: CGFloat = 0
        var alphaFloat: CGFloat = 0
        getRed(&redFloat, green: &greenFloat, blue: &blueFloat, alpha: &alphaFloat)
        let rgb: Int = (Int)(redFloat * 255) << 16 | (Int)(greenFloat * 255) << 8 | (Int)(blueFloat * 255) << 0
        return String(format: "#%06x", rgb)
    }
}
