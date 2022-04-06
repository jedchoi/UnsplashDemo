//
//  UnsplashAPIInterface.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/01.
//

import Foundation
import Combine

protocol UnsplashAPIInterface {
    /// *****************
    ///  getPhotoList
    ///  parameter page: page number to retrieve
    ///  return type: This API returns result of the request as json string
    /// *****************
    func getPhotoList(page: Int) -> AnyPublisher<PhotoListEntity, TraceError>
    
    /// *****************
    ///  searchPhotos
    ///  return type: This API returns result of the request as json string
    /// *****************
    func searchPhotos(page: Int, term: String) -> AnyPublisher<PhotoListEntity, TraceError>
}
