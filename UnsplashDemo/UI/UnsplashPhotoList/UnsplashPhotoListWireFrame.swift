//
//  UnsplashPhotoListWireFrame.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/02.
//

import Foundation
import UIKit

protocol UnsplashPhotoListWireFrameProtocol: AnyObject {
    // Interactor -> Wireframe
    func routeToDetail(index: Int, photos: [PhotoEntity])
}

final class UnsplashPhotoListWireFrame: TabBarInterface {
    weak var view: UIViewController!

    init() {
    }

    func setup() {
        let view = UnsplashPhotoListViewController.instantiate(.UnsplashPhotoList)
        let interactor = UnsplashPhotoListInteractor(view: view, wireframe: self)

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

extension UnsplashPhotoListWireFrame: UnsplashPhotoListWireFrameProtocol {
    func routeToDetail(index: Int, photos: [PhotoEntity]) {
        guard let view = self.view as? UnsplashPhotoListViewController else {
            Logger.track("fail to present")
            return
        }
        Logger.track("route to detail page")
        let wireframe = UnsplashPhotoDetailWireFrame(index: index, photos: photos, delegate: view)
        wireframe.setup()
        wireframe.push(from: view)
    }
}
