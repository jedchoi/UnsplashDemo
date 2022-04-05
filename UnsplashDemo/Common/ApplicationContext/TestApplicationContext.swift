//
//  TestApplicationContext.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/01.
//

import Foundation

class TestApplicationContext: CommonApplicationContext {
    override func configure() {
        register({ FakeUnsplashAPIDataSource() as UnsplashAPIInterface })
//        registerSingleton({ return UnsplashAPIService(dataSource: self.resolve()) as UnsplashAPIServiceInterface })
    }
}
