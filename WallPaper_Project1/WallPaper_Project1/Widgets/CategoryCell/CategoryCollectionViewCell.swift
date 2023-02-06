//
//  ImageCollectionViewCell.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 08/01/2023.
//

import UIKit

final class CategoryCollectionViewCell: UICollectionViewCell, ReuseCellType {
    @IBOutlet private weak var categoryNameLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }

    private func configView() {
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = containerView.frame.size.height / 2
    }

    func bindData(nameCategory: String) {
        categoryNameLabel.text = nameCategory
    }

    func setBackgroundColor(selected: Bool) {
        containerView.backgroundColor = selected ? .seclectedColor : .primaryColor
    }
}
