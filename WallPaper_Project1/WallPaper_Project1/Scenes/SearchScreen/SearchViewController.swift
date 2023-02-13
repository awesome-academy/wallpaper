//
//  SearchViewController.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 07/01/2023.
//

import UIKit

final class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet private weak var noResultLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet private weak var previousPageButton: UIButton!
    @IBOutlet private var pageNumberViewContainers: [UIView]!
    @IBOutlet weak var numberPagePositionContainerView1: UIView!
    @IBOutlet weak var numberPagePositionContainerView2: UIView!
    @IBOutlet weak var numberPagePositionContainerView3: UIView!
    @IBOutlet weak var numberPagePositionContainerView4: UIView!
    @IBOutlet weak var numberPagePositionContainerView5: UIView!
    @IBOutlet private var numberPageLabels: [UILabel]!
    @IBOutlet private var numberPageLabelPosition1: UILabel!
    @IBOutlet private var numberPageLabelPosition2: UILabel!
    @IBOutlet private var numberPageLabelPosition3: UILabel!
    @IBOutlet private var numberPageLabelPosition4: UILabel!
    @IBOutlet private var numberPageLabelPosition5: UILabel!
    @IBOutlet private weak var pageViewContainer: UIView!
    private var videoIconImage: UIImage?
    private var photoIconImage: UIImage?
    private var isPhotoSearched = true
    let dataRepository = DataRepository()
    private let apiCaller = APICaller.shared
    private var images = [Image]()
    private var videos = [Video]()
    private var currentPositionPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        configPageView()
        congfigSearchBarView()
    }
    
    func congfigSearchBarView() {
        videoIconImage = UIImage(systemName: "video.circle.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        photoIconImage = UIImage(systemName: "photo.circle.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter name photo",
            attributes: [.foregroundColor: UIColor.gray]
        )
        let clearButton: UIButton? = searchBar.searchTextField.value(forKey: "_clearButton") as? UIButton
        clearButton?.setImage(clearButton?.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        clearButton?.tintColor = .black
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.leftView?.tintColor = .black
        searchBar.setImage(photoIconImage, for: .bookmark, state: .normal)
    }
    
     func configPageView() {
        previousPageButton.tintColor = .gray
        pageViewContainer.layer.cornerRadius = pageViewContainer.frame.size.height / 2
        pageNumberViewContainers.forEach { containerView in
            containerView.circleView()
        }
    }
    
    @IBAction func numberPageTapped(_ sender: Any) {
        pageNumberViewContainers.forEach { containerView in
            containerView.circleView()
        }
        
    }
    func configCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(nibName: ImageCollectionViewCell.self)
        collectionView.isHidden = true
        collectionView.register(nibName: VideoCollectionViewCell.self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkNetworkConnection()
    }
    
    private func checkNetworkConnection() {
        if NetWorkMonitor.shared.isConnected == false {
            showPopUp(notice: "No Network connection")
        }
    }
    
    func getImagesByName(name: String) {
        dataRepository.getImagesByName(name: name) { [weak self] (data, error) in
            self?.getData(data: data, error: error)
        }
    }
    
    func showCollectionView() {
        if isPhotoSearched {
            if images.count <= 0 {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {return}
                    self.collectionView.isHidden = true
                    self.noResultLabel.text = "No result image for \(self.searchBar.text ?? "")"
                    self.noResultLabel.isHidden = false
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.noResultLabel.isHidden = true
                    self?.collectionView.isHidden = false
                }
            }
        } else {
            if videos.count <= 0 {
                DispatchQueue.main.async { [unowned self] in
                    collectionView.isHidden = true
                    noResultLabel.text = "No result video for \(searchBar.text ?? "")"
                    noResultLabel.isHidden = false
                }
            } else {
                DispatchQueue.main.async { [unowned self] in
                    noResultLabel.isHidden = true
                    collectionView.isHidden = false
                }
            }
        }
    }
    
    func getVideosByName(name: String) {
        dataRepository.getVideosByName(name: name) { [weak self] (data, error) in
            self?.getData(data: data, error: error)
        }
    }
    
    func getData<T>(data: T?, error: Error?) {
        if let error = error {
            showPopUp(notice: "\(error)")
        }
        if let data = data {
            if data.self is Images {
                self.images = (data as? Images)?.photos ?? []
            } else {
                self.videos = (data as? Videos)?.videos ?? []
            }
            self.showCollectionView()
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    func getVideosByPage(numberPage: String, querry: String) {
        let urlApi = "\(BaseUrl.baseUrl.rawValue)\(EndpointAPI.pageVideo.rawValue)?page=\(numberPage)&per_page=15&query=\(querry)"
        dataRepository.getDataByPage(url: urlApi) { [weak self] (data: Videos?, error) in
            self?.getData(data: data, error: error)
        }
    }
    
    func getImagesByPage(numberPage: String, querry: String) {
        let urlApi = "\(BaseUrl.baseUrl.rawValue)\(EndpointAPI.pagePhoto.rawValue)?page=\(numberPage)&per_page=15&query=\(querry)"
        dataRepository.getDataByPage(url: urlApi) { [weak self] (data: Images?, error) in
            self?.getData(data: data, error: error)
        }
    }
    
    func showPopUp(notice: String) {
        let popUpView = PopUpViewController(nibName: "PopUpViewController", bundle: nil)
        popUpView.bindData(notice: notice)
        addChild(popUpView)
        view.addSubview(popUpView.view)
    }
    
    func pageIsSelected(numberPage: String) {
        let querry = searchBar.text ?? ""
        pageNumberViewContainers.forEach { containerView in
            containerView.backgroundColor = .clear
        }
        isPhotoSearched ? getImagesByPage(numberPage: numberPage, querry: querry) : getVideosByPage(numberPage: numberPage, querry: querry)
    }
    
    @IBAction func pagePositionContainerView1(_ sender: UITapGestureRecognizer?) {
        if numberPagePositionContainerView1.backgroundColor != UIColor.seclectedColor {
            currentPositionPage = 1
            let numberPage = numberPageLabels[0].text ?? ""
            pageIsSelected(numberPage: numberPage)
            numberPagePositionContainerView1.backgroundColor = UIColor.seclectedColor
        }
    }
    
    @IBAction func pagePositionContainerView2(_ sender: UITapGestureRecognizer?) {
        if numberPagePositionContainerView2.backgroundColor != UIColor.seclectedColor {
            currentPositionPage = 2
            let numberPage = numberPageLabels[1].text ?? ""
            pageIsSelected(numberPage: numberPage)
            numberPagePositionContainerView2.backgroundColor = UIColor.seclectedColor
        }
    }
    
    @IBAction func pagePositionContainerView3(_ sender: UITapGestureRecognizer?) {
        if numberPagePositionContainerView3.backgroundColor != UIColor.seclectedColor {
            currentPositionPage = 3
            let numberPage = numberPageLabels[2].text ?? ""
            pageIsSelected(numberPage: numberPage)
            numberPagePositionContainerView3.backgroundColor = UIColor.seclectedColor
        }
    }
    
    @IBAction func pagePositionContainerView4(_ sender: UITapGestureRecognizer?) {
        if numberPagePositionContainerView4.backgroundColor != UIColor.seclectedColor {
            currentPositionPage = 4
            let numberPage = numberPageLabels[3].text ?? ""
            pageIsSelected(numberPage: numberPage)
            numberPagePositionContainerView4.backgroundColor = UIColor.seclectedColor
        }
    }
    
    @IBAction func pagePositionContainerView5(_ sender: UITapGestureRecognizer?) {
        if numberPagePositionContainerView5.backgroundColor != UIColor.seclectedColor {
            currentPositionPage = 5
            let numberPage = numberPageLabels[4].text ?? ""
            pageIsSelected(numberPage: numberPage)
            numberPagePositionContainerView5.backgroundColor = UIColor.seclectedColor
        }
    }
    
    @IBAction func previousPageTapped(_ sender: Any) {
        switch currentPositionPage {
        case 1:
            if numberPageLabels[0].text == "1" {
                previousPageButton.tintColor = .gray
            } else {
                numberPageLabels.forEach { numberPageLabel in
                    var numberPage: Int = Int(numberPageLabel.text ?? "0" ) ?? 0
                    numberPage -= 2
                    numberPageLabel.text = "\(numberPage)"
                    if numberPageLabels[0].text == "1" {
                        previousPageButton.tintColor = .gray
                    }
                }
                pagePositionContainerView3(nil)
            }
        case 2:
            pagePositionContainerView1(nil)
        case 3:
            pagePositionContainerView2(nil)
        case 4:
            pagePositionContainerView3(nil)
        case 5:
            pagePositionContainerView4(nil)
        default:
            showPopUp(notice: "Error selecte page")
        }
    }
    
    @IBAction func nextPageTapped(_ sender: Any) {
        switch currentPositionPage {
        case 1:
            pagePositionContainerView2(nil)
        case 2:
            pagePositionContainerView3(nil)
        case 3:
            pagePositionContainerView4(nil)
        case 4:
            pagePositionContainerView5(nil)
        case 5:
            numberPageLabels.forEach {numberPageLabel in
                var numberPage: Int = Int(numberPageLabel.text ?? "0" ) ?? 1
                numberPage += 2
                numberPageLabel.text = "\(numberPage)"
            }
            previousPageButton.tintColor = .white
            pagePositionContainerView4(nil)
        default:
            showPopUp(notice: "Error select page")
        }
    }
    
    func setPage() {
        currentPositionPage = 1
        let numberPage = numberPageLabels[0].text ?? ""
        pageIsSelected(numberPage: numberPage)
        numberPagePositionContainerView1.backgroundColor = UIColor.seclectedColor
        for index in 0...4 {
            numberPageLabels[index].text = "\(index + 1)"
        }
    }
}

extension SearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isPhotoSearched ? images.count : videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isPhotoSearched {
            guard let cell: ImageCollectionViewCell =
                    collectionView.dequeueReusableCell(forIndexPath: indexPath) else {
                showPopUp(notice: "Could not dequeue cell with identifier ")
                return UICollectionViewCell()
            }
            let idImage = images[indexPath.row].id
            cell.setIdImage(id: idImage)
            apiCaller.getImage(imageURL: images[indexPath.row].source.portrait) { [weak self] (data, error)  in
                guard let self = self else { return }
                if let error = error {
                    self.showPopUp(notice: "\(error)")
                }
                if let data = data {
                    if idImage == cell.getIdImage() {
                        DispatchQueue.main.async {
                            cell.setImage(data: data)
                        }
                    }
                }
            }
            return cell
        } else {
            guard let cell: VideoCollectionViewCell =
                    collectionView.dequeueReusableCell(forIndexPath: indexPath) else {
                showPopUp(notice: "Could not dequeue cell with identifier ")
                return UICollectionViewCell()
            }
            let idVideo = videos[indexPath.row].id
            cell.setVideo(video: videos[indexPath.row])
            let url = videos[indexPath.row].videoFiles.first?.link ?? ""
            apiCaller.getVideo(videoURL: url) { [weak self] (player, error) in
                guard let self = self else { return }
                if let error = error {
                    self.showPopUp(notice: "\(error)")
                }
                if idVideo == cell.getIdVideo() {
                    if let player = player {
                        cell.configVideo(player: player)
                    }
                }
            }
            return cell
        }
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailScreen = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailScreen.modalPresentationStyle = .fullScreen
        isPhotoSearched ? detailScreen.bindDataImage(image: images[indexPath.row]) :  detailScreen.bindDataVideo(video: self.videos[indexPath.row])
        present(detailScreen, animated: true, completion: nil)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthCell: CGFloat
        let heightCell: CGFloat
        if isPhotoSearched {
            widthCell = CGFloat((collectionView.frame.width - 22 ) / 3)
            heightCell = CGFloat((collectionView.frame.height - 10 ) / 3)
        } else {
            widthCell = CGFloat((collectionView.frame.width - 10 ) / 2)
            heightCell = CGFloat((collectionView.frame.height - 10 ) / 1.8)
        }
        return CGSize(width: widthCell, height: heightCell)
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        setPage()
        if isPhotoSearched {
            getImagesByName(name: searchBar.text ?? "")
        } else {
            getVideosByName(name: searchBar.text ?? "")
        }
        searchBar.endEditing(true)
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        isPhotoSearched = !isPhotoSearched
        setPage()
        if isPhotoSearched {
            getImagesByName(name: searchBar.text ?? "")
            searchBar.setImage(photoIconImage, for: .bookmark, state: .normal)
            DispatchQueue.main.async { [unowned self] in
                searchBar.searchTextField.placeholder = "Enter name photo"
                collectionView.reloadData()
            }
        } else {
            getVideosByName(name: searchBar.text ?? "")
            searchBar.setImage(videoIconImage, for: .bookmark, state: .normal)
            DispatchQueue.main.async { [weak self] in
                self?.searchBar.searchTextField.placeholder = "Enter name video"
                self?.collectionView.reloadData()
            }
        }
    }
}
