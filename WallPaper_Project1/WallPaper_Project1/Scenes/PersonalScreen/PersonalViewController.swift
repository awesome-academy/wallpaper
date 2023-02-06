//
//  PersonalViewController.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 07/01/2023.
//

import UIKit
import CoreData

final class PersonalViewController: UIViewController {
    @IBOutlet private weak var downloadButton: UIButton!
    @IBOutlet private weak var buttonViewContainer: UIView!
    @IBOutlet private weak var numberDownloadLabel: UILabel!
    @IBOutlet private weak var numberFavoriteLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    private var isPhoto = true
    private var images = [Image]()
    private var videos = [Videos]()
    private let coreData = LocalData.shared
    private var dataDownloadFromCoreData = [CoreDataObject]()
    private var dataFavoriteFromCoreData = [CoreDataObject]()
    private let apiCaller = APICaller.shared
    private let refreshControl = UIRefreshControl()
    private var isDownloadButtonTapped = true

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configCollectionView()
        getDataFromCoreData()
        configRefesh()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateNumberFavoriteAndDownload()
    }

    private func updateNumberFavoriteAndDownload() {
        numberDownloadLabel.text = "\(dataDownloadFromCoreData.count)"
        numberFavoriteLabel.text = "\(dataFavoriteFromCoreData.count)"
    }

    private func configRefesh() {
        collectionView.refreshControl = refreshControl
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }

    @objc private func refreshData(_ sender: Any) {
        getDataFromCoreData()
        updateNumberFavoriteAndDownload()
        DispatchQueue.main.async {[unowned self] in
            refreshControl.endRefreshing()
            collectionView.reloadData()
        }
    }

    private func getDataFromCoreData() {
        coreData.getDataFromCoreData(nameEntity: "DownloadData") {[unowned self] items, error in
            guard error == nil else {
                showPopUp(notice: "Could not fetch. \(String(describing: error))")
                return
            }
            dataDownloadFromCoreData = items.map {
                changeNSManagedObjectToCoreDataObject(nsManagedObject: $0)
            }
        }

        coreData.getDataFromCoreData(nameEntity: "FavoriteData") {[unowned self] items, error in
            guard error == nil else {
                showPopUp(notice: "Could not fetch. \(String(describing: error))")
                return
            }
            dataFavoriteFromCoreData = items.map {
                changeNSManagedObjectToCoreDataObject(nsManagedObject: $0)
            }
        }
    }

    private func configView() {
        buttonViewContainer.layer.cornerRadius = 12
        downloadButton.setTitleColor(.white, for: .normal)
    }

    private func configCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(nibName: ImageCollectionViewCell.self)
        collectionView.register(nibName: VideoCollectionViewCell.self)
    }
    
    private func showPopUp(notice: String) {
        let popUpView = PopUpViewController(nibName: "PopUpViewController", bundle: nil)
        popUpView.bindData(notice: notice)
        DispatchQueue.main.async {[unowned self] in
            addChild(popUpView)
            view.addSubview(popUpView.view)
        }
    }

    private func changeNSManagedObjectToCoreDataObject (nsManagedObject: NSManagedObject) -> CoreDataObject {
        let id = nsManagedObject.value(forKey: "id") as? Int ?? 0
        let width = nsManagedObject.value(forKey: "width") as? Int
        let height = nsManagedObject.value(forKey: "height") as? Int
        let url = nsManagedObject.value(forKey: "url") as? String
        let photographer = nsManagedObject.value(forKey: "photographer") as? String
        let photographerId = nsManagedObject.value(forKey: "photographerId") as? Int
        let avgColor = nsManagedObject.value(forKey: "avgColor") as? String
        let isVideo = nsManagedObject.value(forKey: "isVideo") as? Int
        let videoDuration = nsManagedObject.value(forKey: "videoDuration") as? Int
        return CoreDataObject(id: id, width: width, height: height, url: url, photographer: photographer, photographerId: photographerId, avgColor: avgColor, isVideo: isVideo ?? 0, videoDuration: videoDuration )
    }

    @IBAction func downloadButtonTapped(_ sender: Any) {
        isDownloadButtonTapped = true
        getDataFromCoreData()
        downloadButton.setTitleColor(.white, for: .normal)
        favoriteButton.setTitleColor(.gray, for: .normal)
        DispatchQueue.main.async { [unowned self] in
            collectionView.reloadData()
        }
    }

    @IBAction func favoriteButtonTapped(_ sender: Any) {
        isDownloadButtonTapped = false
        getDataFromCoreData()
        updateNumberFavoriteAndDownload()
        downloadButton.setTitleColor(.gray, for: .normal)
        favoriteButton.setTitleColor(.white, for: .normal)
        DispatchQueue.main.async { [unowned self] in
            collectionView.reloadData()
        }
    }
}

extension PersonalViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isDownloadButtonTapped ? dataDownloadFromCoreData.count : dataFavoriteFromCoreData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = isDownloadButtonTapped ? dataDownloadFromCoreData[indexPath.row] : dataFavoriteFromCoreData[indexPath.row]
        if data.isVideo == 1 {
            guard let cell: VideoCollectionViewCell =
                    collectionView.dequeueReusableCell(forIndexPath: indexPath) else {
                showPopUp(notice: "Could not dequeue cell with identifier ")
                return UICollectionViewCell()
            }
            let idVideo = Int(data.id)
            cell.setInformationFromCoreData(data: data)
            let url = data.url
            apiCaller.getVideo(videoURL: url ?? "") { [weak self] (player, error) in
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
        } else {
            guard let cell: ImageCollectionViewCell =
                    collectionView.dequeueReusableCell(forIndexPath: indexPath) else {
                showPopUp(notice: "Could not dequeue cell with identifier ")
                return UICollectionViewCell()
            }
            let idImage = data.id
            cell.setIdImage(id: idImage)
            let url = data.url
            apiCaller.getImage(imageURL: url ?? "") { [weak self] (data, error)  in
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

extension PersonalViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailScreen = DetailViewController(nibName: DetailViewController.identifier, bundle: nil)
        let data = isDownloadButtonTapped ? dataDownloadFromCoreData[indexPath.row] : dataFavoriteFromCoreData[indexPath.row]
        detailScreen.bindDataFromCoreData(data: data)
        detailScreen.modalPresentationStyle = .fullScreen
        present(detailScreen, animated: true, completion: nil)
    }
}

extension PersonalViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthCell: CGFloat
        let heightCell: CGFloat
        if isPhoto {
            widthCell = CGFloat((collectionView.frame.width - 22) / 3)
            heightCell = CGFloat((collectionView.frame.height - 10) / 3)
        } else {
            widthCell = CGFloat((collectionView.frame.width - 10) / 2)
            heightCell = CGFloat((collectionView.frame.height - 10) / 1.8)
        }
        return CGSize(width: widthCell, height: heightCell)
    }
}
