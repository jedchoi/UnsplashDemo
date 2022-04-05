//
//  GetImageListUseCase.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/01.
//

import Foundation
import Combine

class GetPhotoListUseCase: UseCaseWithParam {
    typealias ReturnValue = PhotoListEntity
    typealias Param = Int
    let dataSource: UnsplashAPIInterface
    var cancelBag = Set<AnyCancellable>()

    init() {
        Logger.track()
        dataSource = ApplicationContext.resolve()
    }
    
    deinit {
        Logger.track()
    }
    
    func execute(param: Param) -> AnyPublisher<ReturnValue, TraceError> {
        Logger.track()
        return dataSource.getPhotoList(page: param)
    }
}
