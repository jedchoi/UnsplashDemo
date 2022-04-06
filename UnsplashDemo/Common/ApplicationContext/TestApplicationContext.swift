//
//  TestApplicationContext.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/01.
//

import Foundation

class TestApplicationContext: CommonApplicationContext {
    override func configure() {
        Logger.track()
        register({ FakeUnsplashAPIDataSource() as UnsplashAPIInterface })
    }
}
