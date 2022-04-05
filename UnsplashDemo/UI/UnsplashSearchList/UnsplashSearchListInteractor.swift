//
//  UnsplashSearchListInteractor.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/03.
//

import Foundation
import Combine

protocol UnsplashSearchListInteractorInputProtocol: AnyObject {
    func onViewDidLoad()
    func itemDidSelect(index: Int, photos: [PhotoEntity])
    func searchPhotos(term: String)
    func willDisplayLastIndex(term: String)
}

final class UnsplashSearchListInteractor {
    weak var view: UnsplashSearchListViewProtocol!
    private var wireframe: UnsplashSearchListWireFrameProtocol!
    var cancelBag = Set<AnyCancellable>()
    var photoInfo: PhotoListEntity

    init(view: UnsplashSearchListViewProtocol, wireframe: UnsplashSearchListWireFrameProtocol) {
        self.view = view
        self.wireframe = wireframe
        self.photoInfo = PhotoListEntity()
    }
    
    private func searchPhotoList(term: String) {
        Logger.track("search \(term) PhotoList")
        let term = term.isEmpty ? "flower" : term
        let param = SearchPhotoInputParam(term: term, page: photoInfo.getNextPage(term: term))
        let usecase = SearchPhotosUseCase()
        usecase.execute(param: param)
            .sink { result in
                switch result {
                case .finished:
                    Logger.track("finished")
                case .failure(let error):
                    Logger.track(error.localizedDescription)
                }
            } receiveValue: { value in
                Logger.track("recieved value:\(value)")
                self.photoInfo.update(term: term, entity: value)
                self.view.displayPhotoList(photos: self.photoInfo.getPhotoList())
                if value.page == 1 {
                    self.view.moveToTopItem()
                }
            }.store(in: &cancelBag)
    }
}


extension UnsplashSearchListInteractor: UnsplashSearchListInteractorInputProtocol {
    func onViewDidLoad() {
        searchPhotoList(term: "")
    }
    
    func searchPhotos(term: String) {
        searchPhotoList(term: term)
    }

    func itemDidSelect(index: Int, photos: [PhotoEntity]) {
        wireframe.routeToDetail(index: index, photos: photos)
    }
    
    func willDisplayLastIndex(term: String) {
        if photoInfo.existNextPage() {
            searchPhotos(term: term)
        }
    }
}
