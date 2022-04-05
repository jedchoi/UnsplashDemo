//
//  UnsplashPhotoDetailInteractor.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/02.
//

import Foundation
import Combine

protocol UnsplashPhotoDetailInteractorInputProtocol: AnyObject {
    func onViewDidLoad()
    func itemDidSelect(id: String)
    func infoButtonTouched()
}

final class UnsplashPhotoDetailInteractor {
    weak var view: UnsplashPhotoDetailViewProtocol!
    private var wireframe: UnsplashPhotoDetailWireFrameProtocol!
    private var index: Int!
    private var photos: [PhotoEntity]
    
    init(view: UnsplashPhotoDetailViewProtocol, wireframe: UnsplashPhotoDetailWireFrameProtocol, index: Int, photos: [PhotoEntity]) {
        Logger.track("")
        self.view = view
        self.wireframe = wireframe
        self.index = index
        self.photos = photos
    }
}

extension UnsplashPhotoDetailInteractor: UnsplashPhotoDetailInteractorInputProtocol {
    func onViewDidLoad() {
        Logger.track("")
        self.view.displayPhotoList(photos: self.photos, index: self.index)
    }
    
    func itemDidSelect(id: String) {

    }
    
    func infoButtonTouched() {
        Logger.track("infoButtonTouched")
    }
}
