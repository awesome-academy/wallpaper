//
//  ImageCollectionViewCell.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 09/01/2023.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell, ReuseCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView = nil
    }

    private func configView() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 12
    }
}
