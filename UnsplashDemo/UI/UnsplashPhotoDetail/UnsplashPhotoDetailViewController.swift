//
//  UnsplashPhotoDetailViewController.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/02.
//

import Foundation
import UIKit

protocol PhotoDetailFocusDelegate: AnyObject {
    func updateFocus(index: Int)
}

protocol UnsplashPhotoDetailViewProtocol: AnyObject {
    // interactor -> View
    func displayPhotoList(photos: [PhotoEntity], index: Int)
    func changeButtonVisible()
}

final class UnsplashPhotoDetailViewController: UIViewController {
    var interactor: UnsplashPhotoDetailInteractorInputProtocol!
    var delegate: PhotoDetailFocusDelegate!
    var photos: [PhotoEntity] = []
    var currentIndex: Int = 0
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var functionButtons: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.track("")
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        interactor.onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Logger.track("currentIndex:\(currentIndex)")
        self.hideTabBar()
        self.setupNavigationController()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.photoCollectionView.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .left, animated: false)
            self.navigationItem.title = self.photos[self.currentIndex].artistName
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Logger.track("Detail will disappear. updateFocus")
        self.delegate?.updateFocus(index: currentIndex)
    }
    
    private func setupNavigationController() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.navigationBar.backIndicatorImage = UIImage.init(systemName: "xmark")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage.init(systemName: "xmark")
        self.navigationController?.navigationBar.tintColor = .label
    }
}

// MARK: - ViewProtocol
extension UnsplashPhotoDetailViewController: UnsplashPhotoDetailViewProtocol {
    func displayPhotoList(photos: [PhotoEntity], index: Int) {
        Logger.track("")
        self.photos = photos
        self.currentIndex = index
    }

    func changeButtonVisible() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let isHidden = !self.infoButton.isHidden
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.infoButton.isHidden = isHidden
                self?.functionButtons.isHidden = isHidden
                self?.navigationController?.isNavigationBarHidden = isHidden
            }
        }
    }
}

extension UnsplashPhotoDetailViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            for cell in self.photoCollectionView.visibleCells {
                guard let indexPath = self.photoCollectionView.indexPath(for: cell) else { return }
                Logger.track("\(indexPath)")
                self.currentIndex = indexPath.item
                self.navigationItem.title = self.photos[self.currentIndex].artistName
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor.itemDidSelect()
    }
}

extension UnsplashPhotoDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoDetailCollectionViewCell", for: indexPath) as? PhotoDetailCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(photoInfo: self.photos[indexPath.item])
        return cell
    }
}

extension UnsplashPhotoDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
