//
//  MainTabHomeInteractor.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/02.
//

import Foundation

protocol MainTabHomeInteractorInputProtocol: AnyObject {
    // View -> Interactor
}

final class MainTabHomeInteractor: MainTabHomeInteractorInputProtocol {
    weak var view: MainTabHomeViewProtocol!
    var wireframe: MainTabHomeWireframeProtocol!

    init(view: MainTabHomeViewProtocol, wireframe: MainTabHomeWireframeProtocol) {
        self.view = view
        self.wireframe = wireframe
    }
}
