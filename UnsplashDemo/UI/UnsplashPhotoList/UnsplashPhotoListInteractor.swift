//
//  UnsplashPhotoListInteractor.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/02.
//

import Foundation
import Combine

protocol UnsplashPhotoListInteractorInputProtocol: AnyObject {
    func onViewDidLoad()
    func itemDidSelect(index: Int, photos: [PhotoEntity])
    func willDisplayLastIndex()
}

final class UnsplashPhotoListInteractor {
    weak var view: UnsplashPhotoListViewProtocol!
    private var wireframe: UnsplashPhotoListWireFrameProtocol!
    var cancelBag = Set<AnyCancellable>()
    var photoInfo: PhotoListEntity

    init(view: UnsplashPhotoListViewProtocol, wireframe: UnsplashPhotoListWireFrameProtocol) {
        self.view = view
        self.wireframe = wireframe
        self.photoInfo = PhotoListEntity()
    }
    
    private func getPhotoList() {
        let usecase = GetPhotoListUseCase()
        usecase.execute(param: photoInfo.getNextPage())
            .sink { result in
                switch result {
                case .finished:
                    Logger.track("finished")
                case .failure(let error):
                    Logger.track(error.localizedDescription)
                }
            } receiveValue: { value in
                Logger.track("recieved value:\(value)")
                self.photoInfo.update(term: "", entity: value)
                self.view.displayPhotoList(photos: self.photoInfo.getPhotoList())
            }.store(in: &cancelBag)
    }
}


extension UnsplashPhotoListInteractor: UnsplashPhotoListInteractorInputProtocol {
    func onViewDidLoad() {
        getPhotoList()
    }

    func itemDidSelect(index: Int, photos: [PhotoEntity]) {
        wireframe.routeToDetail(index: index, photos: photos)
    }
    
    func willDisplayLastIndex() {
        if photoInfo.existNextPage() {
            getPhotoList()
        }
    }
}
