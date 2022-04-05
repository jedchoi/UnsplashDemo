//
//  UnsplashPhotoListViewController.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/02.
//

import Foundation
import UIKit

protocol UnsplashPhotoListViewProtocol: AnyObject {
    // interactor -> View
    func displayPhotoList(photos: [PhotoEntity])
}

final class UnsplashPhotoListViewController: UIViewController {
    var interactor: UnsplashPhotoListInteractorInputProtocol!
    var photos: [PhotoEntity] = []
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.onViewDidLoad()
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Logger.track("view will appear")
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationItem.title = "Unsplash"
        showTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = ""
    }
}

// MARK: - ViewProtocol
extension UnsplashPhotoListViewController: UnsplashPhotoListViewProtocol {
    func displayPhotoList(photos: [PhotoEntity]) {
        Logger.track("")
        self.photos = photos
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.photoCollectionView.reloadData()
        }
    }
}

extension UnsplashPhotoListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < photos.count else {
            Logger.track("indexPath: \(indexPath), apps.coount: \(photos.count)")
            return
        }
        interactor.itemDidSelect(index: indexPath.item, photos: self.photos)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        Logger.track("willDisplay: \(indexPath.item)")
        if indexPath.item == photos.count - 1 {
            interactor.willDisplayLastIndex()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self, velocity.y != 0 else { return }
            if velocity.y < 0 {
                self.showTabBar()
            } else {
                self.hideTabBar()
            }
        }
    }
}

extension UnsplashPhotoListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(photoInfo: self.photos[indexPath.item])
        return cell
    }
}

extension UnsplashPhotoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width*CGFloat(photos[indexPath.item].getHeightRatio()))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension UnsplashPhotoListViewController: PhotoDetailFocusDelegate {
    func updateFocus(index: Int) {
        Logger.track("PhotoList ViewController updateFocus")
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.photoCollectionView.scrollToItem(at: IndexPath(item:index, section: 0), at: .bottom, animated: false)
        }
    }
}
