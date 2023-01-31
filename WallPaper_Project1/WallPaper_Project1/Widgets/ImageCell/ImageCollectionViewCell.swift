//
//  ImageCollectionViewCell.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 09/01/2023.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell, ReuseCellType {
    @IBOutlet private weak var imageView: UIImageView?
    private let apiCaller = APICaller.shared
    private var idImage: Int?

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
        imageView?.setImageColor(color: .loadBackgroundColor)
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

    func getIdImage() -> Int? {
    return idImage
    }

    func setIdImage(id: Int ) {
        idImage = id
    }

    func setImage(data: Data) {
        imageView?.image = UIImage(data: data)
    }
}
