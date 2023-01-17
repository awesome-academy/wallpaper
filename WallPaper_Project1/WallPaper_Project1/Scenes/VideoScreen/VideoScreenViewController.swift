//
//  VideoScreenViewController.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 07/01/2023.
//

import UIKit
import AVFoundation

final class VideoScreenViewController: UIViewController {
    @IBOutlet private weak var containerCategoriesView: UIView!
    @IBOutlet private weak var videoCollectionView: UICollectionView!
    @IBOutlet private weak var categoryCollectionView: UICollectionView!
    private let apiCaller = APICaller.shared
    private let dataRepository = DataRepository()
    private var videos = [Video]()
    private var indexCategorySelected = 0
    private var urlNextPage = ""
    private let refreshControl = UIRefreshControl()
    private var isLoadMore = false
    private var loadingBottomView: LoadCollectionReusableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        configCategoryView()
        configVideoView()
        configRefesh()
        getVideosPopular()
    }

    private func configRefesh() {
        videoCollectionView.refreshControl = refreshControl
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)

    }

    @objc private func refreshData(_ sender: Any) {
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.videoCollectionView.reloadData()
        }
    }

    private func configCategoryView() {
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(nibName: CategoryCollectionViewCell.self)
        containerCategoriesView.layer.cornerRadius = containerCategoriesView.frame.height / 2
        categoryCollectionView.layer.cornerRadius = categoryCollectionView.frame.height / 2
    }

    private func configVideoView() {
        videoCollectionView.delegate = self
        videoCollectionView.dataSource = self
        videoCollectionView.register(nibName: VideoCollectionViewCell.self)
        videoCollectionView.registerHeaderAndFooterView(nibName: LoadCollectionReusableView.self, isHeader: true)
        videoCollectionView.registerHeaderAndFooterView(nibName: LoadCollectionReusableView.self, isHeader: false)
    }

    private func showPopUp(notice: String) {
        let popUpView = PopUpViewController(nibName: "PopUpViewController", bundle: nil)
        popUpView.bindData(notice: notice)
        addChild(popUpView)
        view.addSubview(popUpView.view)
    }

    private func getVideosPopular() {
        dataRepository.getVideosPopular() { [weak self] (data, error) in
            guard let self = self else { return }
            if let error = error {
                self.showPopUp(notice: "\(error)")
            }
            if let data = data {
                self.urlNextPage = data.nextPage
                self.videos = data.videos ?? []
                DispatchQueue.main.async {
                    self.videoCollectionView.reloadData()
                }
            }
        }
    }

    private func getVideoByName(name: String) {
        dataRepository.getVideosByName(name: name) { [weak self] (data, error) in
            guard let self = self else { return }
            if let error = error {
                self.showPopUp(notice: "\(error)")
            }
            if let data = data {
                self.urlNextPage = data.nextPage
                self.videos = data.videos ?? []
                DispatchQueue.main.async {
                    self.videoCollectionView.reloadData()
                }
            }
        }
    }

    private func getVideosNextPage(url: String) {
        dataRepository.getVideosNextPage(nextUrl: url){ [weak self] (data, error) in
            guard let self = self else { return }
            if let error = error {
                self.showPopUp(notice: "\(error)")
            }
            if let data = data {
                self.videos.append(contentsOf: data.videos ?? [])
                self.urlNextPage = data.nextPage
                DispatchQueue.main.async {
                    self.videoCollectionView.reloadData()
                }
                self.isLoadMore = false
                self.loadingBottomView?.hide()
            }
        }
    }

    private func loadMore(url: String) {
        if !isLoadMore {
            isLoadMore = true
            getVideosNextPage(url: url)
        }
    }

}

extension VideoScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == categoryCollectionView ? 12 : videos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            guard let cell: CategoryCollectionViewCell =
                    collectionView.dequeueReusableCell(forIndexPath: indexPath) else {
                showPopUp(notice: "Could not dequeue cell with identifier ")
                return UICollectionViewCell()
            }
            return cell
        } else {
            guard let cell: VideoCollectionViewCell =
                    collectionView.dequeueReusableCell(forIndexPath: indexPath) else {
                showPopUp(notice: "Could not dequeue cell with identifier ")
                return UICollectionViewCell()
            }
            let idVideo = videos[indexPath.row].id
            cell.setVideo(video: videos[indexPath.row])
            let url = videos[indexPath.row].videoFiles[2].link
            apiCaller.getVideo(videoURL: url) { [weak self] (player, error) in
                guard let self = self else { return }
                if let error = error {
                    self.showPopUp(notice: "\(error)")
                }
                if idVideo == cell.getIdVideo() {
                    if let player = player {
                        cell.configVideo(player: player)
                    }
                }
            }
            return cell
        }
    }
}

extension VideoScreenViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if videoCollectionView == collectionView {
            let detailScreen = DetailViewController(nibName: "DetailViewController", bundle: nil)
            detailScreen.modalPresentationStyle = .fullScreen
            detailScreen.bindDataVideo(video: self.videos[indexPath.row])
            present(detailScreen, animated: true, completion: nil)
        } else {
            indexCategorySelected = indexPath.row
            categoryCollectionView.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let lastIndex = videos.count - 1
        if indexPath.row == lastIndex {
            loadMore(url: urlNextPage)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(forIndexPath: indexPath,
                                                                               viewForSupplementaryElementOfKind: kind) else {
                showPopUp(notice: "Could not dequeue cell with identifier ")
                return UICollectionReusableView()
            }
            header.hide()
            return header
        case UICollectionView.elementKindSectionFooter:
            guard let footer = collectionView.dequeueReusableSupplementaryView(forIndexPath: indexPath,
                                                                               viewForSupplementaryElementOfKind: kind) else {
                showPopUp(notice: "Could not dequeue cell with identifier ")
                return UICollectionReusableView()
            }
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
