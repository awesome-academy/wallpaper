//
//  LoadCollectionReusableView.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 12/01/2023.
//

import UIKit

final class LoadCollectionReusableView: UICollectionReusableView, ReuseCellType {

    @IBOutlet private weak var loadViewIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setStatusIndicator(isActive: Bool) {
        if isActive {
            loadViewIndicator.startAnimating()
        } else {
            loadViewIndicator.stopAnimating()
        }
    }

    func hide() {
        DispatchQueue.main.async { [weak self] in
            self?.frame = CGRect.null
        }
    }
    
   func show(frame: CGRect) {
        DispatchQueue.main.async { [weak self] in
            self?.frame = frame
        }
    }
}
