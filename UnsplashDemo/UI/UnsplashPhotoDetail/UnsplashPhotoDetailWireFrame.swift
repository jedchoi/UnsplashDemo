//
//  UnsplashPhotoDetailWireFrame.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/02.
//

import Foundation
import UIKit

protocol UnsplashPhotoDetailWireFrameProtocol: AnyObject {
    // Interactor -> Wireframe
}

final class UnsplashPhotoDetailWireFrame {
    var delegate: PhotoDetailFocusDelegate!
    weak var view: UIViewController!
    private var index: Int!
    private var photos: [PhotoEntity]

    init(index: Int, photos: [PhotoEntity], delegate: PhotoDetailFocusDelegate) {
        Logger.track("")
        self.index = index
        self.photos = photos
        self.delegate = delegate
    }

    func setup() {
        let view = UnsplashPhotoDetailViewController.instantiate(.UnsplashPhotoDetail)
        let interactor = UnsplashPhotoDetailInteractor(view: view, wireframe: self, index: self.index, photos: photos)

        view.interactor = interactor
        view.delegate = delegate
        self.view = view
    }
    
    func push(from presentedViewController: UIViewController) {
        Logger.track("")
        guard let view = self.view else {
            Logger.track("fail to present")
            return
        }
        presentedViewController.navigationController?.pushViewController(view, animated: true)
    }
    
}

extension UnsplashPhotoDetailWireFrame: UnsplashPhotoDetailWireFrameProtocol {

}
