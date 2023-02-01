//
//  PersonalViewController.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 07/01/2023.
//

import UIKit

final class PersonalViewController: UIViewController {
    @IBOutlet private weak var downloadButton: UIButton!
    @IBOutlet private weak var buttonViewContainer: UIView!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    private var isPhoto = true
    private var images = [Image]()
    private var videos = [Videos]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configCollectionView()
    }

    private func configView() {
        buttonViewContainer.layer.cornerRadius = 12
        downloadButton.setTitleColor(.white, for: .normal)
    }

    private func configCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(nibName: ImageCollectionViewCell.self)
        collectionView.register(nibName: VideoCollectionViewCell.self)
    }
    
    private func showPopUp(notice: String) {
        let popUpView = PopUpViewController(nibName: "PopUpViewController", bundle: nil)
        popUpView.bindData(notice: notice)
        addChild(popUpView)
        view.addSubview(popUpView.view)
    }

    @IBAction func downloadButtonTapped(_ sender: Any) {
        downloadButton.setTitleColor(.white, for: .normal)
        favoriteButton.setTitleColor(.gray, for: .normal)
        DispatchQueue.main.async { [unowned self] in
            collectionView.reloadData()
        }
    }

    @IBAction func favoriteButtonTapped(_ sender: Any) {
        downloadButton.setTitleColor(.gray, for: .normal)
        favoriteButton.setTitleColor(.white, for: .normal)
        DispatchQueue.main.async { [unowned self] in
            collectionView.reloadData()
        }
    }
}

extension PersonalViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//       update after
        return 15
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isPhoto {
            guard let cell: ImageCollectionViewCell =
                    collectionView.dequeueReusableCell(forIndexPath: indexPath) else {
                showPopUp(notice: "Could not dequeue cell with identifier ")
                return UICollectionViewCell()
            }
            return cell
        } else {
            guard let cell: VideoCollectionViewCell =
                    collectionView.dequeueReusableCell(forIndexPath: indexPath) else {
                showPopUp(notice: "Could not dequeue cell with identifier ")
                return UICollectionViewCell()
            }
            return cell
        }
    }
}

extension PersonalViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailScreen = DetailViewController(nibName: DetailViewController.identifier, bundle: nil)
        detailScreen.modalPresentationStyle = .fullScreen
        present(detailScreen, animated: true, completion: nil)
    }
}

extension PersonalViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthCell: CGFloat
        let heightCell: CGFloat
        if isPhoto {
            widthCell = CGFloat((collectionView.frame.width - 22) / 3)
            heightCell = CGFloat((collectionView.frame.height - 10) / 3)
        } else {
            widthCell = CGFloat((collectionView.frame.width - 10) / 2)
            heightCell = CGFloat((collectionView.frame.height - 10) / 1.8)
        }
        return CGSize(width: widthCell, height: heightCell)
    }
}
