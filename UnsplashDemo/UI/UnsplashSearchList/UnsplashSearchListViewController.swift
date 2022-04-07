//
//  UnsplashSearchListViewController.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/03.
//

import Foundation
import UIKit

protocol UnsplashSearchListViewProtocol: AnyObject {
    // interactor -> View
    func displayPhotoList(photos: [PhotoEntity])
    func moveToTopItem()
}

final class UnsplashSearchListViewController: UIViewController {
    var interactor: UnsplashSearchListInteractorInputProtocol!
    var photos: [PhotoEntity] = []
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.onViewDidLoad()
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        setupNavigationController()
        setCollectionViewLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Logger.track("view will appear")
        self.navigationController?.hidesBarsOnSwipe = false
        showTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = ""
    }
    
    private func setupNavigationController() {
        let searchController = UISearchController(searchResultsController:  nil)
        searchController.searchBar.placeholder = "Search photos, collections, users"
        searchController.searchBar.delegate = self
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
    }
    
    private func setCollectionViewLayout() {
        let layout = WaterFallLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        searchCollectionView.collectionViewLayout = layout
    }
}

// MARK: - ViewProtocol
extension UnsplashSearchListViewController: UnsplashSearchListViewProtocol {
    func displayPhotoList(photos: [PhotoEntity]) {
        Logger.track("")
        guard !photos.isEmpty else {
            return
        }
        self.photos = photos
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let layout = self.searchCollectionView.collectionViewLayout as? WaterFallLayout {
                layout.update(photos: photos)
            }
            self.searchCollectionView.reloadData()
        }
    }
    
    func moveToTopItem() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.searchCollectionView.scrollToItem(at: IndexPath(item:0, section: 0), at: .top, animated: false)
        }
    }
}

extension UnsplashSearchListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let key = searchBar.text else {
            Logger.track("no text")
            return
        }
        interactor.searchPhotos(term: key)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        Logger.track()
        interactor.searchPhotos(term: "")
    }
}

extension UnsplashSearchListViewController: UICollectionViewDelegate {
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
            interactor.willDisplayLastIndex(term: self.navigationItem.searchController?.searchBar.text ?? "")
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

extension UnsplashSearchListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as? SearchCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(photoInfo: self.photos[indexPath.item])
        return cell
    }
}

extension UnsplashSearchListViewController: PhotoDetailFocusDelegate {
    func updateFocus(index: Int) {
        Logger.track("Search ViewController updateFocus")
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.searchCollectionView.scrollToItem(at: IndexPath(item:index, section: 0), at: .centeredVertically, animated: false)
        }
    }
}
