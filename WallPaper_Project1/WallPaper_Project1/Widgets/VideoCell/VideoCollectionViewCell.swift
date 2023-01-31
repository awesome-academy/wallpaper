//
//  VideoCollectionViewCell.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 13/01/2023.
//

import UIKit
import AVFoundation

class VideoCollectionViewCell: UICollectionViewCell, ReuseCellType {
    private var player: AVPlayer?
    private let layerPlayer = AVPlayerLayer()
    private var idVideo: Int?
    private var videoDuration: Int = 1
    private let apiCaller = APICaller.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        congfigBackgroundView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateView()
    }
    
    private func congfigBackgroundView() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressCell(_:)))
        self.addGestureRecognizer(longPressGesture)
        layer.cornerRadius = 12
        backgroundColor = UIColor.loadBackgroundColor
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
    
    func configVideo(player: AVPlayer) {
        self.player = player
    }
    
    private func updateView() {
        layerPlayer.player = player
        layerPlayer.frame = contentView.bounds
        layerPlayer.videoGravity = .resizeAspectFill
        contentView.layer.addSublayer(layerPlayer)
        player?.volume = 0
        player?.play()
    }
    
    func setVideo(video: Video) {
        idVideo = video.id
        videoDuration = video.duration
    }

    func setInformationFromCoreData(data: CoreDataObject) {
        idVideo = data.id
        videoDuration = data.videoDuration ?? 0
    }
    
    func getIdVideo() -> Int? {
        return idVideo
    }
    
}
