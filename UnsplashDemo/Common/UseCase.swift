//
//  UseCase.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/01.
//

import Foundation
import Combine

protocol UseCase: AnyObject {
    func execute()
}

protocol UseCaseWithoutParam: AnyObject {
    associatedtype ReturnValue

    func execute() -> AnyPublisher<ReturnValue, TraceError>
}

protocol UseCaseWithParam: AnyObject {
    associatedtype Param
    associatedtype ReturnValue

    func execute(param: Param) -> AnyPublisher<ReturnValue, TraceError>
}
