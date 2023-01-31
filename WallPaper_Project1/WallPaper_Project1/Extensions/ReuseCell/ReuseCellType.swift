//
//  ReuseCell.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 11/01/2023.
//

import Foundation
import UIKit

extension ReuseCellType where Self: AnyObject {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(nibName name: T.Type, atBundle bundleClass: AnyClass? = nil)
    where T: ReuseCellType {
        let identifier = T.defaultReuseIdentifier
        let nibName = T.nibName
        var bundle: Bundle?
        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }
        register(UINib(nibName: nibName, bundle: bundle), forCellWithReuseIdentifier: identifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T? where T: ReuseCellType {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            return nil
        }
        return cell
    }

    func registerHeaderAndFooterView<T: UICollectionReusableView>(nibName name: T.Type, atBundle bundleClass: AnyClass? = nil, isHeader: Bool)
    where T: ReuseCellType {
        let identifier = T.defaultReuseIdentifier
        let nibName = T.nibName
        var bundle: Bundle?
        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }
        register(UINib(nibName: nibName, bundle: bundle),
                 forSupplementaryViewOfKind: isHeader ? UICollectionView.elementKindSectionHeader : UICollectionView.elementKindSectionFooter,
                 withReuseIdentifier: identifier)
    }

    func dequeueReusableSupplementaryView<T: LoadCollectionReusableView>
    (forIndexPath indexPath: IndexPath, viewForSupplementaryElementOfKind kind: String) -> T? where T: ReuseCellType {
        guard let cell = self.dequeueReusableSupplementaryView(ofKind: kind,
                                                               withReuseIdentifier: T.defaultReuseIdentifier,
                                                               for: indexPath) as? T else {
            return nil
        }
        return cell
    }
}
