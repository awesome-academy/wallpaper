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
    @IBOutlet private weak var downloadButton: UIButton!
    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var detailImageView: UIImageView!
    @IBOutlet private weak var arrowTriangleImageView: UIImageView!
    @IBOutlet private weak var authorNameLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var informationView: UIView!
    @IBOutlet private weak var colorImageLabel: UILabel!
    @IBOutlet private weak var bottomButtonViewContainer: UIView!
    @IBOutlet private weak var topButtonViewContainer: UIView!
    @IBOutlet private weak var imageIdLabel: UILabel!
    @IBOutlet private weak var heightImageLabel: UILabel!
    @IBOutlet private weak var widthImageLabel: UILabel!
    private let apiCaller = APICaller.shared
    private var imageData: Data?
    private var player: AVPlayer?
    private let playerLayer = AVPlayerLayer()
    private var videoDuration: Int = 1
    private var video: Video?
    private var isVideo = false
    private var videoUrl = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    private func configView() {
        informationView.isHidden = true
        arrowTriangleImageView.isHidden = true
        downloadButton.layer.cornerRadius = 20
        informationView.layer.cornerRadius = 12
        detailImageView.setImageColor(color: .loadBackgroundColor)
        bottomButtonViewContainer.setGradientBackground(colorTop: UIColor.clear.cgColor,
                                                        colorBottom: UIColor.black.cgColor)
        topButtonViewContainer.setGradientBackground(colorTop: UIColor.black.cgColor,
                                                     colorBottom: UIColor.clear.cgColor)
    }

    @objc private func longPressCell(_ gesture: UIGestureRecognizer) {
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

    @IBAction private func downloadButtonTapped(_ sender: Any) {
        let waitingLoadingViewController = WaitingLoadingViewController(nibName: "WaitingLoadingViewController", bundle: nil)
        waitingLoadingViewController.updateView(status: true)
        present(waitingLoadingViewController, animated: true)
        if isVideo {
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

    @IBAction private func infomationButtonTapped(_ sender: Any) {
        informationView.isHidden = !informationView.isHidden
        arrowTriangleImageView.isHidden = !arrowTriangleImageView.isHidden
    }

    @IBAction private func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }

    private func showPopUp(notice: String) {
        let popUpView = PopUpViewController(nibName: "PopUpViewController", bundle: nil)
        popUpView.bindData(notice: notice)
        addChild(popUpView)
        view.addSubview(popUpView.view)
    }

    func bindDataImage(image: Image ) {
        isVideo = false
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
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.updateImageView(image: image)
        }
    }

    private func updateImageView(image: Image) {
        authorNameLabel.text = image.photographer
        heightImageLabel.text = "Height: \(image.height)"
        widthImageLabel.text = "Width: \(image.width)"
        imageIdLabel.text = "Id: \(image.id)"
        colorImageLabel.text = "Color: \(image.avgColor)"
    }

    func bindDataVideo(video: Video) {
        isVideo = true
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

    private func updateVideoView() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressCell(_:)))
        imageContainerView.addGestureRecognizer(longPressGesture)
        playerLayer.player = player
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        imageContainerView.layer.addSublayer(playerLayer)
        player?.volume = 0
    }

    private func updateInformationVideo(video: Video) {
        detailImageView.isHidden = true
        authorNameLabel.text = video.user.name
        heightImageLabel.text = "Height: \(video.videoFiles[0].height)"
        widthImageLabel.text = "Width: \(video.videoFiles[0].width)"
        imageIdLabel.text = "Id: \(video.id)"
        colorImageLabel.text = "Color: no"
    }
}
