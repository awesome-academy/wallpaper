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
    private var notice = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.cornerRadius = 12
    }
    override func viewDidLayoutSubviews() {
        self.noticeLabel?.text = notice
    }
    func bindData(notice: String) {
        self.notice = notice
    }

    @IBAction private func closeButtonTapped(_ sender: Any) {
        self.view.removeFromSuperview()
    }
}
