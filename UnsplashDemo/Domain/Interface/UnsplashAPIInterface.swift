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

struct PhotoListEntity {
    var term: String
    var total_page: Int
    var page: Int
    var photos: [PhotoEntity]
    
    init() {
        term = ""
        total_page = 0
        page = 0
        photos = []
    }
    
    init(term: String, total_page: Int, page: Int, photos: [PhotoEntity]) {
        self.term = term
        self.total_page = total_page
        self.page = page
        self.photos = photos
    }
    
    mutating func update(term: String, entity: PhotoListEntity) {
        if term == self.term, page != 0 {
            self.page = entity.page
            self.photos.append(contentsOf: entity.photos)
        } else {
            self.term = term
            self.total_page = entity.total_page
            self.page = entity.page
            self.photos = entity.photos
        }
    }
    
    func existNextPage() -> Bool {
        return total_page > page
    }
    
    func getNextPage(term: String = "") -> Int {
        if term != self.term {
            return 1
        }
        return page + 1
    }
    
    func getPhotoList() -> [PhotoEntity] {
        return photos
    }
}

struct PhotoEntity {
    var artistName: String
    var imageUrl: String
    var isSponsorship: Bool
    var width: Int
    var height: Int
    
    func getHeightRatio() -> Float {
        return Float(height) / Float(width)
    }
}
