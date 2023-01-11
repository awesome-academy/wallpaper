//
//  ImageViewController.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 06/01/2023.
//

import UIKit

final class ImageViewController: UIViewController {

    @IBOutlet private weak var imageCollectionView: UICollectionView!
    @IBOutlet private weak var containerCategoriesView: UIView!
    @IBOutlet private weak var categoryCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configCategoryView()
        configImageView()
    }

    private func configCategoryView() {
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(nibName: CategoryCollectionViewCell.self)
        containerCategoriesView.layer.cornerRadius = containerCategoriesView.frame.height / 2
        categoryCollectionView.layer.cornerRadius = categoryCollectionView.frame.height / 2
    }

    private func configImageView() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(nibName: ImageCollectionViewCell.self)
    }
}

extension ImageViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == categoryCollectionView ? 10 : 20
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            let cell: CategoryCollectionViewCell =
            collectionView.dequeueReusableCell(forIndexPath: indexPath)
            return cell
        } else {
            let cell: ImageCollectionViewCell =
            collectionView.dequeueReusableCell(forIndexPath: indexPath)
            return cell
        }

    }
}

extension ImageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailScreen = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailScreen.modalPresentationStyle = .fullScreen
        present(detailScreen, animated: true, completion: nil)
    }
}
