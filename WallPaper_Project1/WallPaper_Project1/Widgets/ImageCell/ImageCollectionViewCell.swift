//
//  ImageCollectionViewCell.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 09/01/2023.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell, ReuseCell {
    @IBOutlet private weak var imageView: UIImageView?
    private let apiCaller = APICaller.shared

    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
        setLoadBackgroundColor()
    }

    private func setLoadBackgroundColor() {
        self.imageView?.setImageColor(color: .loadBackgroundColor)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
    }

    private func showPopUp(notice: String) {
        let popUpView = PopUpViewController(nibName: "PopUpViewController", bundle: nil)
        popUpView.bindData(notice: notice)
        contentView.addSubview(popUpView.view)
    }

    private func configView() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 12
    }

    func bindData(image: Image ) {
        apiCaller.getImage(imageURL: image.source.portrait) { [weak self] (data, error)  in
            guard let self = self else { return }
            if let error = error {
                self.showPopUp(notice: "\(error)")
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.imageView?.image = UIImage(data: data)
                }
            }
        }
    }
}
