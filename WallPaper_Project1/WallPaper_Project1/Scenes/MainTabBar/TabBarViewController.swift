//
//  TabBarViewController.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 07/01/2023.
//

import UIKit

final class TabBarViewController: UITabBarController {
    let imageViewController = ImageViewController()
    let videoScreenViewController = VideoScreenViewController()
    let searchViewController = SearchViewController()
    let personalViewController = PersonalViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        customTabBar()
    }

    private func configView() {
        setViewControllers([imageViewController, videoScreenViewController,
                                 searchViewController, personalViewController], animated: true)
        configTabBarItem()
    }

    private func configTabBarItem() {
        tabBar.tintColor = UIColor.seclectedColor
        tabBar.unselectedItemTintColor = .black
        if let items = tabBar.items {
            items.enumerated().forEach { (index, item) in
                switch ItemTabBar(rawValue: index) {
                case .photoScreen:
                    item.title = ItemTabBar.photoScreen.getTitle()
                    item.image = UIImage(systemName: ItemTabBar.photoScreen.getIconName())
                case .livePhotoScreen:
                    item.title = ItemTabBar.livePhotoScreen.getTitle()
                    item.image = UIImage(systemName: ItemTabBar.livePhotoScreen.getIconName())
                case .searchScreen:
                    item.title = ItemTabBar.searchScreen.getTitle()
                    item.image = UIImage(systemName: ItemTabBar.searchScreen.getIconName())
                case .personalScreen:
                    item.title = ItemTabBar.personalScreen.getTitle()
                    item.image = UIImage(systemName: ItemTabBar.personalScreen.getIconName())
                default:
                    break
                }
            }
        }
    }

    private func customTabBar() {
        drawLayerTabBar()
        if let items = tabBar.items {
            items.forEach { item in
                item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -15, right: 0)
            }
        }
        tabBar.itemWidth = 40
        tabBar.itemPositioning = .centered
    }

    private func drawLayerTabBar() {
        let layer = CAShapeLayer()
        let roundRect = CGRect(x: 50, y: tabBar.bounds.minY, width: tabBar.bounds.width - 100,
                               height: tabBar.bounds.height + 12)
        layer.path = UIBezierPath(roundedRect: roundRect, cornerRadius: (tabBar.frame.width / 2)).cgPath
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        layer.shadowRadius = 25.0
        layer.shadowOpacity = 0.5
        layer.borderWidth = 1.0
        layer.opacity = 1.0
        layer.isHidden = false
        layer.masksToBounds = false
        layer.fillColor = UIColor(#colorLiteral(red: 0.9336340427, green: 0.9336340427, blue: 0.9336340427, alpha: 1)).cgColor
        tabBar.layer.insertSublayer(layer, at: 0)
    }

}
