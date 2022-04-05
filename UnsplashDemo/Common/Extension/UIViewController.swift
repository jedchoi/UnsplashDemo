//
//  ViewController.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/02.
//

import Foundation
import UIKit

extension UIViewController {
    class var storyboardID: String {
        return "\(self)"
    }
    
    static func instantiate(_ storyboard: Storyboard) -> Self {
        return storyboard.viewController(viewControllerClass: self)
    }
    
    func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    func hideTabBar() {
        self.tabBarController?.tabBar.alpha = 0.0
        self.tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY)
    }
    
    func showTabBar() {
        let height = self.tabBarController?.tabBar.frame.height ?? 0.0
        self.tabBarController?.tabBar.alpha = 1.0
        self.tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY - height)
    }
}


enum Storyboard: String {
    case UnsplashPhotoList
    case UnsplashPhotoDetail
    case UnsplashSearchList
}

extension Storyboard {
    var instance: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: Bundle.main)
    }

    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID

        guard let viewContorller = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(rawValue) Storyboard")
        }
        return viewContorller
    }
}
