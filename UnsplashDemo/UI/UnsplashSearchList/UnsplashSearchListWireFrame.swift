//
//  UnsplashSearchListWireFrame.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/03.
//

import Foundation
import UIKit

protocol UnsplashSearchListWireFrameProtocol: AnyObject {
    // Interactor -> Wireframe
    func routeToDetail(index: Int, photos: [PhotoEntity])
}

final class UnsplashSearchListWireFrame: TabBarInterface {
    weak var view: UIViewController!

    init() {
    }

    func setup() {
        let view = UnsplashSearchListViewController.instantiate(.UnsplashSearchList)
        let interactor = UnsplashSearchListInteractor(view: view, wireframe: self)

        view.interactor = interactor
        self.view = view
    }
    
    func present(fromWindow window: UIWindow) {
        window.rootViewController = view
        window.makeKeyAndVisible()
    }

    func configuredViewController() -> UIViewController {
        return view
    }

    func push(from presentedViewController: UIViewController) {
        guard let view = self.view else {
            Logger.track("fail to present")
            return
        }
        view.navigationController?.pushViewController(view, animated: true)
    }
    
}

extension UnsplashSearchListWireFrame: UnsplashSearchListWireFrameProtocol {
    func routeToDetail(index: Int, photos: [PhotoEntity]) {
        guard let view = self.view as? UnsplashSearchListViewController else {
            Logger.track("fail to present")
            return
        }
        Logger.track("route to detail page")
        let wireframe = UnsplashPhotoDetailWireFrame(index: index, photos: photos, delegate: view)
        wireframe.setup()
        wireframe.push(from: view)
    }
}
