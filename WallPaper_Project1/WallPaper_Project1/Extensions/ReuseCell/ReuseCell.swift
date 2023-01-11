//
//  ReuseCell.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 11/01/2023.
//

import Foundation
import UIKit

extension ReuseCell where Self : AnyObject {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(nibName name: T.Type, atBundle bundleClass: AnyClass? = nil) where T: ReuseCell {
        let identifier = T.defaultReuseIdentifier
        let nibName = T.nibName
        var bundle: Bundle? = nil
        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }
        register(UINib(nibName: nibName, bundle: bundle), forCellWithReuseIdentifier: identifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReuseCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
              fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
          }

          return cell
      }

}
