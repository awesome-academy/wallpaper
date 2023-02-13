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
    func configView() {
        containerView?.layer.cornerRadius = 12
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sleep(1)
    }

    func updateView(status: Bool) {
        if status {
            DispatchQueue.main.async { [weak self] in
                self?.containerView?.isHidden = true
                self?.loadActivityIndicator?.startAnimating()
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.containerView?.isHidden = false
                self?.loadActivityIndicator?.stopAnimating()
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
    }
}
