//
//  DetailViewController.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 10/01/2023.
//

import UIKit
import AVFoundation
import Photos

final class DetailViewController: UIViewController {
    static let identifier = "DetailViewController"
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet private weak var imageContainerView: UIView?
    @IBOutlet private weak var detailImageView: UIImageView!
    @IBOutlet private weak var arrowTriangleImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel?
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet private weak var informationView: UIView!
    @IBOutlet weak var colorImageLabel: UILabel?
    @IBOutlet private weak var bottomButtonViewContainer: UIView!
    @IBOutlet weak var topButtonViewContainer: UIView!
    @IBOutlet weak var imageIdLabel: UILabel?
    @IBOutlet weak var heightImageLabel: UILabel?
    @IBOutlet weak var widthImageLabel: UILabel?
    private let apiCaller = APICaller.shared
    private var imageData: Data?
    private var player: AVPlayer?
    private let playerLayer = AVPlayerLayer()
    private var videoDuration: Int = 1
    private var video: Video?
    private var isVideo = false
    private var videoUrl = ""
    private var imageUrl = ""
    let coreData = LocalData.shared
    private var isFavorited = false
    private var dataToSave: Media?
    var id = 0
    private var authorUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        checkIsFavorited()
    }
    
     func configView() {
        informationView?.isHidden = true
        arrowTriangleImageView.isHidden = true
        favoriteButton.tintColor = isFavorited ? UIColor.systemPink : UIColor.white
        downloadButton.layer.cornerRadius = 20
        informationView.layer.cornerRadius = 12
        detailImageView.setImageColor(color: .loadBackgroundColor)
        bottomButtonViewContainer.setGradientBackground(colorTop: UIColor.clear.cgColor,
                                                        colorBottom: UIColor.black.cgColor)
        topButtonViewContainer.setGradientBackground(colorTop: UIColor.black.cgColor,
                                                     colorBottom: UIColor.clear.cgColor)
    }
    
    func saveToCoreData (entityName: String) {
        coreData.addToCoreData(data: dataToSave, nameEntity: entityName) { [unowned self] error in
            showPopUp(notice: "\(String(describing: error))")
        }
    }
    
    func checkIsFavorited() {
        if coreData.checkInCoreData(id: id, nameEntity: "FavoriteData") {
            isFavorited = true
            favoriteButton.tintColor = .systemPink
        } else {
            isFavorited = false
            favoriteButton.tintColor = .white
        }
    }
    
    @objc  func longPressCell(_ gesture: UIGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.began {
            if Int( player!.currentTime().seconds) >= (videoDuration) - 1 {
                player?.seek(to: CMTime.zero)
            }
            player?.play()
        }
        if gesture.state == UIGestureRecognizer.State.ended {
            player?.pause()
        }
    }
    
    @IBAction func authorLabelTapped(_ sender: Any) {
        let authorViewController = AuthorViewController(nibName: AuthorViewController.identifier, bundle: nil)
        authorViewController.bindData(authorName: authorNameLabel?.text ?? "", authorUrl: authorUrl)
        authorViewController.modalPresentationStyle = .fullScreen
        present(authorViewController, animated: true, completion: nil)
    }
    
    @IBAction func downloadButtonTapped(_ sender: Any) {
        let waitingLoadingViewController = WaitingLoadingViewController(nibName: "WaitingLoadingViewController", bundle: nil)
        waitingLoadingViewController.updateView(status: true)
        present(waitingLoadingViewController, animated: true)
        if isVideo {
            saveToCoreData(entityName: "DownloadData")
            guard let url = URL(string: videoUrl) else {
                return
            }
            DispatchQueue.global().async { [weak self] in
                let urlData = NSData(contentsOf: url)
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                let filePath = "\(documentsPath)/tempFile.mp4"
                DispatchQueue.main.async {
                    urlData?.write(toFile: filePath, atomically: true)
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                    }) { (completed, error) in
                        if let error = error {
                            self?.showPopUp(notice: "\(error)")
                        }
                        if completed {
                            waitingLoadingViewController.updateView(status: false)
                        }
                    }
                }
            }
        } else {
            saveToCoreData(entityName: "DownloadData")
            if let imageData = imageData {
                if let imageDownload = UIImage(data: imageData) {
                    DispatchQueue.global().async {
                        UIImageWriteToSavedPhotosAlbum(imageDownload, nil, nil, nil)
                    }
                    waitingLoadingViewController.updateView(status: false)
                }
            }
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        if isFavorited {
            coreData.removeCoreData(id: id, nameEntity: "FavoriteData") {[unowned self] error in
                showPopUp(notice: "\(String(describing: error))")
            }
            favoriteButton.tintColor = .white
            isFavorited = false
        } else {
            saveToCoreData(entityName: "FavoriteData")
            favoriteButton.tintColor = .systemPink
            isFavorited = true
        }
    }
    
    @IBAction func infomationButtonTapped(_ sender: Any) {
        informationView.isHidden = !informationView.isHidden
        arrowTriangleImageView.isHidden = !arrowTriangleImageView.isHidden
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdatePersonalViewController"), object: nil, userInfo: nil)
        self.dismiss(animated: true)
    }
    
    func showPopUp(notice: String) {
        let popUpView = PopUpViewController(nibName: "PopUpViewController", bundle: nil)
        popUpView.bindData(notice: notice)
        DispatchQueue.main.async { [weak self] in
            self?.addChild(popUpView)
            self?.view.addSubview(popUpView.view)
        }

    }
    
    func imageToMedia(image: Image) -> Media{
        let data = Media(id: image.id,
                         width: image.width,
                         height: image.height,
                         url: image.source.portrait,
                         photographer: image.photographer,
                         photographerId: image.photographerId,
                         photographerUrl: image.photographerUrl,
                         avgColor: image.avgColor,
                         isVideo: 0,
                         videoDuration: nil)
        return data
    }
    
    func bindDataImage(image: Image ) {
        id = image.id
        isVideo = false
        authorUrl = image.photographerUrl
        dataToSave = imageToMedia(image: image)
        apiCaller.getImage(imageURL: image.source.portrait) { [weak self] (data, error)  in
            guard let self = self else { return }
            if let error = error {
                self.showPopUp(notice: "\(error)")
            }
            if let data = data {
                self.imageData = data
                DispatchQueue.main.async {
                    self.detailImageView.image = UIImage(data: data)
                }
            }
        }
        DispatchQueue.main.async {[weak self] in
            self?.updateImageView(image: image)
        }
    }
    
     func updateImageView(image: Image) {
         authorNameLabel?.text = image.photographer
        heightImageLabel?.text = "Height: \(image.height)"
        widthImageLabel?.text = "Width: \(image.width)"
        imageIdLabel?.text = "Id: \(image.id)"
        colorImageLabel?.text = "Color: \(image.avgColor)"
    }
    
     func videoToMedia(video: Video) -> Media{
        let data = Media(id: video.id,
                         width: video.width,
                         height: video.height,
                         url: video.videoFiles[0].link,
                         photographer: video.user.name,
                         photographerId: video.user.id,
                         photographerUrl: video.user.url,
                         avgColor: "", isVideo: 1,
                         videoDuration: video.duration)
        return data
    }
    
    func bindDataVideo(video: Video) {
        id = video.id
        isVideo = true
        authorUrl = video.user.url
        dataToSave = videoToMedia(video: video)
        videoUrl = video.videoFiles[0].link
        apiCaller.getVideo(videoURL: videoUrl) { [weak self] (player, error) in
            guard let self = self else { return }
            if let error = error {
                self.showPopUp(notice: "\(error)")
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.player = player
                self.updateVideoView()
                self.updateInformationVideo(video: video)
            }
        }
    }
    
    func updateVideoView() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressCell(_:)))
        imageContainerView?.addGestureRecognizer(longPressGesture)
        playerLayer.player = player
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        imageContainerView?.layer.addSublayer(playerLayer)
        player?.volume = 0
    }
    
    func updateInformationVideo(video: Video) {
        detailImageView.isHidden = true
        authorNameLabel?.text = video.user.name
        heightImageLabel?.text = "Height: \(video.videoFiles[0].height)"
        widthImageLabel?.text = "Width: \(video.videoFiles[0].width)"
        imageIdLabel?.text = "Id: \(video.id)"
        colorImageLabel?.text = "Color: no"
    }
    
    func informationFromCoreData(data: Media) {
        if data.isVideo == 1 {
            detailImageView.isHidden = true
        }
        authorNameLabel?.text = data.photographer
        heightImageLabel?.text = "Height: \(data.height ?? 0)"
        widthImageLabel?.text = "Width: \(data.width ?? 0))"
        imageIdLabel?.text = "Id: \(data.id)"
        colorImageLabel?.text = "Color: no"
    }
    
    func bindDataFromCoreData(data: Media) {
        dataToSave = data
        id = data.id
        authorUrl = data.photographerUrl ?? ""
        if data.isVideo == 1 {
            isVideo = true
            videoUrl = data.url ?? ""
            apiCaller.getVideo(videoURL: videoUrl) { [weak self] (player, error) in
                guard let self = self else { return }
                if let error = error {
                    self.showPopUp(notice: "\(error)")
                }
                DispatchQueue.main.async {
                    self.player = player
                    self.updateVideoView()
                    self.informationFromCoreData(data: data)
                }
            }
        } else {
            isVideo = false
            apiCaller.getImage(imageURL: data.url ?? "") { [weak self] (data, error)  in
                guard let self = self else { return }
                if let error = error {
                    self.showPopUp(notice: "\(error)")
                }
                if let data = data {
                    self.imageData = data
                    DispatchQueue.main.async {
                        self.detailImageView.image = UIImage(data: data)
                    }
                }
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.informationFromCoreData(data: data)
            }
        }
    }
}
