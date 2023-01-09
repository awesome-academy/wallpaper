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
        self.configView()
    }

    private func configView() {
        self.tabBar.backgroundColor = .white
        self.setViewControllers([imageViewController, videoScreenViewController,
                                 searchViewController, personalViewController], animated: true)
        self.configTabBarItem()
    }

    private func configTabBarItem() {
        guard let items = self.tabBar.items else {return}
        for index in 0..<items.count {
            switch ItemTabBar(rawValue: index) {
            case .photoScreen:
                items[index].title = ItemTabBar.photoScreen.getTitle()
                items[index].image = UIImage(systemName: ItemTabBar.photoScreen.getIconName())
            case .livePhotoScreen:
                items[index].title = ItemTabBar.livePhotoScreen.getTitle()
                items[index].image = UIImage(systemName: ItemTabBar.livePhotoScreen.getIconName())
            case .searchScreen:
                items[index].title = ItemTabBar.searchScreen.getTitle()
                items[index].image = UIImage(systemName: ItemTabBar.searchScreen.getIconName())
            case .personalScreen:
                items[index].title = ItemTabBar.personalScreen.getTitle()
                items[index].image = UIImage(systemName: ItemTabBar.personalScreen.getIconName())
            default:
                break
            }
        }
    }

}
