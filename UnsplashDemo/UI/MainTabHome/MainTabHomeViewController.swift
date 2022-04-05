//
//  MainTabHomeViewController.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/02.
//

import Foundation
import UIKit

protocol MainTabHomeViewProtocol: AnyObject {
    // Interactor -> View
}

final class MainTabHomeViewController: UITabBarController {
    var interactor: MainTabHomeInteractorInputProtocol!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lockOrientation(.portrait)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureTabBarItem()
        self.selectedIndex = 4
    }
}

extension MainTabHomeViewController: MainTabHomeViewProtocol {
    
}

private extension MainTabHomeViewController {
    func configureTabBarItem() {
        guard let tabViewControllers = viewControllers else { return }
        tabBar.barTintColor = .black

        let items = [
            UITabBarItem(title: "", image: UIImage.init(systemName: "photo.fill"), tag: 1),
            UITabBarItem(title: "", image: UIImage.init(systemName: "magnifyingglass"), tag: 2),
            UITabBarItem(title: "", image: UIImage.init(systemName: "plus.app.fill"), tag: 3),
            UITabBarItem(title: "", image: UIImage.init(systemName: "person.circle.fill"), tag: 4)
        ]

        (0 ..< tabViewControllers.count).forEach { tabViewControllers[$0].tabBarItem = items[$0] }
    }
}
