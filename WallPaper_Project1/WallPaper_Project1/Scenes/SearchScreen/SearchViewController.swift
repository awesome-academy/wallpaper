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
    private let dataRepository = DataRepository()
    private let apiCaller = APICaller.shared
    private var images = [Image]()
    private var videos = [Video]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        configPageView()
        congfigSearchBarView()
    }

    private func congfigSearchBarView() {
        videoIconImage = UIImage(systemName: "video.circle.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        photoIconImage = UIImage(systemName: "photo.circle.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter name photo",
            attributes: [.foregroundColor: UIColor.gray]
        )
        let clearButton: UIButton? = searchBar.searchTextField.value(forKey: "_clearButton") as? UIButton
        clearButton?.setImage(clearButton?.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        clearButton?.tintColor = .black
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.textColor = .black
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
        collectionView.register(nibName: VideoCollectionViewCell.self)
    }

    private func getImagesByName(name: String) {
        dataRepository.getImagesByName(name: name) { [weak self] (data, error) in
            guard let self = self else { return }
            if let error = error {
                self.showPopUp(notice: "\(error)")
            }
            if let data = data {
                self.images = data.photos ?? []
                self.showCollectionView()
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }

    private func showCollectionView() {
        if isPhotoSearched {
            if images.count <= 0 {
                DispatchQueue.main.async { [unowned self] in
                    collectionView.isHidden = true
                    noResultLabel.text = "No result image for \(searchBar.text ?? "")"
                    noResultLabel.isHidden = false
                }
            } else {
                DispatchQueue.main.async { [unowned self] in
                    noResultLabel.isHidden = true
                    collectionView.isHidden = false
                }
            }
        } else {
            if videos.count <= 0 {
                DispatchQueue.main.async { [unowned self] in
                    collectionView.isHidden = true
                    noResultLabel.text = "No result video for \(searchBar.text ?? "")"
                    noResultLabel.isHidden = false
                }
            } else {
                DispatchQueue.main.async { [unowned self] in
                    noResultLabel.isHidden = true
                    collectionView.isHidden = false
                }
            }
        }
    }

    private func getVideosByName(name: String) {
        dataRepository.getVideosByName(name: name) { [weak self] (data, error) in
            guard let self = self else { return }
            if let error = error {
                self.showPopUp(notice: "\(error)")
            }
            if let data = data {
                self.videos = data.videos ?? []
                self.showCollectionView()
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }

    private func showPopUp(notice: String) {
        let popUpView = PopUpViewController(nibName: "PopUpViewController", bundle: nil)
        popUpView.bindData(notice: notice)
        DispatchQueue.main.sync {
            addChild(popUpView)
            view.addSubview(popUpView.view)
        }
    }
}
extension SearchViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isPhotoSearched ? images.count : videos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isPhotoSearched {
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
        } else {
            guard let cell: VideoCollectionViewCell =
                    collectionView.dequeueReusableCell(forIndexPath: indexPath) else {
                showPopUp(notice: "Could not dequeue cell with identifier ")
                return UICollectionViewCell()
            }
            let idVideo = videos[indexPath.row].id
            cell.setVideo(video: videos[indexPath.row])
            let url = videos[indexPath.row].videoFiles.first?.link ?? ""
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

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailScreen = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailScreen.modalPresentationStyle = .fullScreen
        isPhotoSearched ? detailScreen.bindDataImage(image: images[indexPath.row]) :  detailScreen.bindDataVideo(video: self.videos[indexPath.row])
        present(detailScreen, animated: true, completion: nil)
    }
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

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if isPhotoSearched {
            getImagesByName(name: searchBar.text ?? "")
        } else {
            getVideosByName(name: searchBar.text ?? "")
        }
        searchBar.endEditing(true)
    }

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        isPhotoSearched = !isPhotoSearched
        if isPhotoSearched {
            getImagesByName(name: searchBar.text ?? "")
            searchBar.setImage(photoIconImage, for: .bookmark, state: .normal)
            DispatchQueue.main.async { [unowned self] in
                searchBar.searchTextField.placeholder = "Enter name photo"
                collectionView.reloadData()
            }
        } else {
            getVideosByName(name: searchBar.text ?? "")
            searchBar.setImage(videoIconImage, for: .bookmark, state: .normal)
            DispatchQueue.main.async { [unowned self] in
                searchBar.searchTextField.placeholder = "Enter name video"
                collectionView.reloadData()
            }
        }
    }
}
