//
//  SearchViewController.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 07/01/2023.
//

import UIKit

final class SearchViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var noResultLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private var pageNumberViewContainers: [UIView]!
    @IBOutlet private weak var numberPagePositionContainerView1: UIView!
    @IBOutlet private weak var numberPagePositionContainerView2: UIView!
    @IBOutlet private weak var numberPagePositionContainerView3: UIView!
    @IBOutlet private weak var numberPagePositionContainerView4: UIView!
    @IBOutlet private weak var numberPagePositionContainerView5: UIView!
    @IBOutlet private var numberPageLabels: [UILabel]!
    @IBOutlet private weak var pageViewContainer: UIView!
    private var videoIconImage: UIImage?
    private var photoIconImage: UIImage?
    private var isPhotoSearched = true

    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        configPageView()
        congfigSearchBarView()
    }

    private func congfigSearchBarView() {
        videoIconImage = UIImage(systemName: "video.circle.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        photoIconImage = UIImage(systemName: "photo.circle.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        searchBar.searchTextField.placeholder =  "Enter name photo"
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.leftView?.tintColor = .black
        searchBar.setImage(photoIconImage, for: .bookmark, state: .normal)
    }

    private func configPageView() {
        pageViewContainer.layer.cornerRadius = pageViewContainer.frame.size.height / 2
        pageNumberViewContainers.forEach { containerView in
            containerView.circleView()
        }
    }

    private func configCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(nibName: ImageCollectionViewCell.self)
        collectionView.isHidden = true
    }

    private func showPopUp(notice: String) {
        DispatchQueue.main.sync {
            let popUpView = PopUpViewController(nibName: "PopUpViewController", bundle: nil)
            popUpView.bindData(notice: notice)
            addChild(popUpView)
            view.addSubview(popUpView.view)
        }
    }
}
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Update after
        return 15
    }

   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ImageCollectionViewCell =
                collectionView.dequeueReusableCell(forIndexPath: indexPath) else {
            showPopUp(notice: "Could not dequeue cell with identifier ")
            return UICollectionViewCell()
        }
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate {
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthCell: CGFloat
        let heightCell: CGFloat
        if isPhotoSearched {
            widthCell = CGFloat((collectionView.frame.width - 22 ) / 3)
            heightCell = CGFloat((collectionView.frame.height - 10 ) / 3)
        } else {
            widthCell = CGFloat((collectionView.frame.width - 10 ) / 2)
            heightCell = CGFloat((collectionView.frame.height - 10 ) / 1.8)
        }
        return CGSize(width: widthCell, height: heightCell)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        noResultLabel.isHidden = true
        collectionView.isHidden = false
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        isPhotoSearched = !isPhotoSearched
        if isPhotoSearched {
            searchBar.setImage(photoIconImage, for: .bookmark, state: .normal)
            DispatchQueue.main.async { [unowned self] in
                collectionView.reloadData()
                searchBar.searchTextField.placeholder = "Enter name photo"
            }
        } else {
            searchBar.setImage(videoIconImage, for: .bookmark, state: .normal)
            DispatchQueue.main.async { [unowned self] in
                searchBar.searchTextField.placeholder = "Enter name video"
                collectionView.reloadData()
            }
        }
    }
}
