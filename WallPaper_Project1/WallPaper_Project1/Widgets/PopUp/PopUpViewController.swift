//
//  PopUpViewController.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 11/01/2023.
//

import UIKit

final class PopUpViewController: UIViewController {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var noticeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.cornerRadius = 12
    }

    func bindData(notice: String) {
        noticeLabel.text = notice
    }

    @IBAction private func closeButtonTapped(_ sender: Any) {
        self.view.removeFromSuperview()
    }
}
