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
    private let dataRepository = DataRepository()
    private var images = [Image]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configCategoryView()
        configImageView()
        getImageCurated()
    }

    private func getImageByName(name: String) {
        dataRepository.getImagesByName(name: name) { [weak self] (data, error) in
            guard let self = self else { return }
            if let error = error {
                self.showPopUp(notice: "\(error)")
            }
            if let data = data {
                self.images = data
                DispatchQueue.main.async {
                    self.imageCollectionView.reloadData()
                }
            }
        }
    }

    private func getImageCurated() {
        dataRepository.getImagesCurated() { [weak self] (data, error) in
            guard let self = self else { return }
            if let error = error {
                self.showPopUp(notice: "\(error)")
            }
            if let data = data {
                self.images = data
                DispatchQueue.main.async {
                    self.imageCollectionView.reloadData()
                }
            }
        }
    }

    private func showPopUp(notice: String) {
        let popUpView = PopUpViewController(nibName: "PopUpViewController", bundle: nil)
        popUpView.bindData(notice: notice)
        addChild(popUpView)
        view.addSubview(popUpView.view)
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
        return collectionView == categoryCollectionView ? 10 : images.count
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
            let colorCell = UIColor(hexString: images[indexPath.row].avgColor, alpha: 0.5)
            cell.bindData(image: images[indexPath.row])
            return cell
        }
    }
}

extension ImageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailScreen = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailScreen.modalPresentationStyle = .fullScreen
        let backgroundColor = UIColor(hexString: images[indexPath.row].avgColor, alpha: 0.5)
        detailScreen.setLoadBackGroundColor(color: backgroundColor)
        detailScreen.bindData(image: images[indexPath.row])
        present(detailScreen, animated: true, completion: nil)
    }
}
