//
//  MainTabHomeWireFrame.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/02.
//

import Foundation
import UIKit
import Combine

protocol TabBarInterface {
    func configuredViewController() -> UIViewController
}

protocol MainTabHomeWireframeProtocol: AnyObject {
    // Presenter -> Wireframe
}

final class MainTabHomeWireframe: MainTabHomeWireframeProtocol {
    var view: UITabBarController!

    var tabBarWireframes: [TabBarInterface]

    init() {
        tabBarWireframes = [TabBarInterface]()
    }
    
    func setup() {
        let view = MainTabHomeViewController()
        let interactor = MainTabHomeInteractor(view: view, wireframe: self)
        view.interactor = interactor
        self.view = view
        
        addTabViewControllers()
    }
    
    func present(fromWindow window: UIWindow) {
        window.rootViewController = view
        window.makeKeyAndVisible()
    }
    
    private func addTabViewControllers() {
        var tabViewContorllers = [UIViewController]()
        tabViewContorllers.append(getPhotoListViewController())
        tabViewContorllers.append(getSearchListViewController())
        tabViewContorllers.append(UploadViewController())
        tabViewContorllers.append(UserInfoViewController())
        
        self.view.setViewControllers(tabViewContorllers, animated: false)
    }
    
    private func getPhotoListViewController() -> UIViewController {
        let photoListWireFrame = UnsplashPhotoListWireFrame()
        photoListWireFrame.setup()
        let navigationController = UINavigationController(rootViewController: photoListWireFrame.configuredViewController())
        navigationController.navigationBar.barTintColor = .black
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        return navigationController
    }
    
    private func getSearchListViewController() -> UIViewController {
        let searchListWireFrame = UnsplashSearchListWireFrame()
        searchListWireFrame.setup()
        let navigationController = UINavigationController(rootViewController: searchListWireFrame.configuredViewController())
        navigationController.navigationBar.barTintColor = .black
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        return navigationController
    }
}
