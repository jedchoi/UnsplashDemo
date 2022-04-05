//
//  ProdApplicationContext.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/01.
//

import Foundation

class ProdApplicationContext: CommonApplicationContext {
    override func configure() {
        Logger.track()
        register({ UnsplashAPIDataSource() as UnsplashAPIInterface })
//        registerSingleton({ UnsplashAPIService(dataSource: self.resolve()) as UnsplashAPIServiceInterface })
    }
}
