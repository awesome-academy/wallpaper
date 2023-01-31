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
    private let apiCaller = APICaller.shared
    private var images = [Image]()
    private var isLoadMore = false
    private var urlNextPage = ""
    private var loadingBottomView: LoadCollectionReusableView?
    private let refreshControl = UIRefreshControl()
    private var indexCategorySelected = 0
    private let categories = ["Currated", "Nature", "Sea", "Sky", "Animal", "Car", "Robot"]

    override func viewDidLoad() {
        super.viewDidLoad()
        configCategoryView()
        configImageView()
        getImageCurated()
        configRefesh()
    }

    private func getImageCurated() {
        dataRepository.getImagesCurated() { [unowned self] (data, error) in
            getImageData(data: data, error: error)
        }
    }

    private func switchCategory(category: String) {
        images = []
        switch CategoryPhoto(rawValue: category) {
        case .animal:
            getImagesByName(name: CategoryPhoto.animal.rawValue)
        case .car:
            getImagesByName(name: CategoryPhoto.car.rawValue)
        case .curated:
            getImageCurated()
        case .nature:
            getImagesByName(name: CategoryPhoto.nature.rawValue)
        case .robot:
            getImagesByName(name: CategoryPhoto.robot.rawValue)
        case .sea:
            getImagesByName(name: CategoryPhoto.sea.rawValue)
        case .sky:
            getImagesByName(name: CategoryPhoto.sky.rawValue)
        default:
            break
        }
    }

    private func getImagesByName(name: String) {
        dataRepository.getImagesByName(name: name) { [unowned self] (data, error) in
            getImageData(data: data, error: error)
        }
    }

    private func getImagesNextPage(url: String) {
        dataRepository.getImagesInNextPage(url: url) { [unowned self] (data, error) in
            getImageData(data: data, error: error)
            isLoadMore = false
            loadingBottomView?.hide()
        }
    }

    private func getImageData(data: Images?, error: Error?) {
        if let error = error {
            showPopUp(notice: "\(error)")
        }
        if let data = data {
            images.append(contentsOf: data.photos ?? [])
            urlNextPage = data.nextPage ?? ""
            DispatchQueue.main.async { [weak self] in
                self?.imageCollectionView.reloadData()
            }
        }
    }

    private func configRefesh() {
        imageCollectionView.refreshControl = refreshControl
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }

    @objc private func refreshData(_ sender: Any) {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.imageCollectionView.reloadData()
        }
    }

    private func showPopUp(notice: String) {
        DispatchQueue.main.sync {
            let popUpView = PopUpViewController(nibName: "PopUpViewController", bundle: nil)
            popUpView.bindData(notice: notice)
            addChild(popUpView)
            view.addSubview(popUpView.view)
        }
    }

    private func loadMore(url: String) {
        if !isLoadMore {
            isLoadMore = true
            getImagesNextPage(url: url)
        }
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
        imageCollectionView.registerHeaderAndFooterView(nibName: LoadCollectionReusableView.self, isHeader: false)
        imageCollectionView.registerHeaderAndFooterView(nibName: LoadCollectionReusableView.self, isHeader: true)
    }
}

extension ImageViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == categoryCollectionView ? categories.count : images.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            guard let cell: CategoryCollectionViewCell =
                    collectionView.dequeueReusableCell(forIndexPath: indexPath) else {
                showPopUp(notice: "Could not dequeue cell with identifier ")
                return UICollectionViewCell()
            }
            cell.setBackgroundColor(selected: indexCategorySelected == indexPath.row)
            cell.bindData(nameCategory: categories[indexPath.row])
            return cell
        } else {
            guard let cell: ImageCollectionViewCell =
                    collectionView.dequeueReusableCell(forIndexPath: indexPath) else {
                showPopUp(notice: "Could not dequeue cell with identifier ")
                return UICollectionViewCell()
            }
            let idImage = images[indexPath.row].id
            cell.setIdImage(id: idImage)
            apiCaller.getImage(imageURL: images[indexPath.row].source.portrait) { [weak self] (data, error)  in
                guard let self = self else { return }
                if let error = error {
                    self.showPopUp(notice: "\(error)")
                }
                if let data = data {
                    if idImage == cell.getIdImage() {
                        DispatchQueue.main.async {
                            cell.setImage(data: data)
                        }
                    }
                }
            }
            return cell
        }
    }
}

extension ImageViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if imageCollectionView == collectionView {
            let detailScreen = DetailViewController(nibName: "DetailViewController", bundle: nil)
            detailScreen.modalPresentationStyle = .fullScreen
            detailScreen.bindDataImage(image: images[indexPath.row])
            present(detailScreen, animated: true, completion: nil)
        } else {
            indexCategorySelected = indexPath.row
            switchCategory(category: categories[indexPath.row])
            categoryCollectionView.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let lastIndex = images.count - 1
        if indexPath.row == lastIndex {
            loadMore(url: urlNextPage)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                forIndexPath: indexPath, viewForSupplementaryElementOfKind: kind) else {
                showPopUp(notice: "Could not dequeue cell with identifier ")
                return UICollectionReusableView()
            }
            header.backgroundColor = .blue
            header.hide()
            return header
        case UICollectionView.elementKindSectionFooter:
            guard let footer = collectionView.dequeueReusableSupplementaryView(
                forIndexPath: indexPath, viewForSupplementaryElementOfKind: kind) else {
                showPopUp(notice: "Could not dequeue cell with identifier ")
                return UICollectionReusableView()
            }
            footer.setStatusIndicator(isActive: true)
            loadingBottomView = footer
            return footer
        default:
            assert(false, "Unexpected element kind")
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplayingSupplementaryView view: UICollectionReusableView,
                        forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingBottomView?.setStatusIndicator(isActive: false)
        }
    }
}
