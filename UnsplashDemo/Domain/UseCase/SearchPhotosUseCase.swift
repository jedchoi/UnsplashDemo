//
//  SearchPhotosUseCase.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/01.
//

import Foundation
import Combine

struct SearchPhotoInputParam {
    var term: String
    var page: Int
}

class SearchPhotosUseCase: UseCaseWithParam {
    typealias Param = SearchPhotoInputParam
    typealias ReturnValue = PhotoListEntity
    let dataSource: UnsplashAPIInterface

    init() {
        Logger.track()
        dataSource = ApplicationContext.resolve()
    }
    
    deinit {
        Logger.track()
    }
    
    func execute(param: Param) -> AnyPublisher<ReturnValue, TraceError> {
        Logger.track()
        return dataSource.searchPhotos(page: param.page, term: param.term)
    }
}
