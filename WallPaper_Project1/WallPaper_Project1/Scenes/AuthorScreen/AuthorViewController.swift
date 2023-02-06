//
//  AuthorViewController.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 07/01/2023.
//

import UIKit
import WebKit

final class AuthorViewController: UIViewController {
    static let identifier = "AuthorViewController"
    @IBOutlet private var authorNameLabel: UILabel?
    @IBOutlet private weak var webView: WKWebView!
    private var authorName = ""
    private var authorUrl = ""
    private let timeoutInterval: TimeInterval = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configWebView(url: authorUrl)
    }

    private func configWebView(url: String) {
        guard let url = URL(string: url) else {
            return
        }
        let request = URLRequest(url: url , cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutInterval)
        webView.load(request)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        authorNameLabel?.text = authorName
    }

    @IBAction private func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }

    func bindData(authorName: String, authorUrl: String) {
        self.authorName = authorName
        self.authorUrl = authorUrl
    }
}
