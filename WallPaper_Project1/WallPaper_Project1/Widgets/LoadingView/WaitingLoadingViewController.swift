//
//  WaitingLoadingViewController.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 13/01/2023.
//

import UIKit

final class WaitingLoadingViewController: UIViewController {

    @IBOutlet private weak var loadActivityIndicator: UIActivityIndicatorView?
    @IBOutlet private weak var containerView: UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    private func configView() {
        containerView?.layer.cornerRadius = 12
        loadActivityIndicator?.startAnimating()
        containerView?.isHidden = true
    }

    func updateView(status: Bool) {
        if status {
            loadActivityIndicator?.startAnimating()
        } else {
            loadActivityIndicator?.stopAnimating()
            containerView?.isHidden = false
            self.dismiss(animated: true)
        }
    }
}
