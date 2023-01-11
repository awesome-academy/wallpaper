//
//  DetailViewController.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 10/01/2023.
//

import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet private weak var downloadButton: UIButton!
    @IBOutlet private weak var detailImageView: UIImageView!

    @IBOutlet private weak var arrowTriangleImageView: UIImageView!
    @IBOutlet private weak var informationView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    private func configView() {
        informationView.isHidden = true
        arrowTriangleImageView.isHidden = true
        downloadButton.layer.cornerRadius = 20
        informationView.layer.cornerRadius = 12
    }

    @IBAction private func infomationButtonTapped(_ sender: Any) {
        informationView.isHidden = !informationView.isHidden
        arrowTriangleImageView.isHidden = !arrowTriangleImageView.isHidden
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)

    }
}
