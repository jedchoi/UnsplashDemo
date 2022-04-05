//
//  UnsplashData.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/04.
//

import Foundation

struct UnsplashSearchedData: Codable {
    var total_photos: Int
    var total_pages: Int
    var photos: [UnsplashPhoto]
    
    enum CodingKeys: String, CodingKey {
        case total_photos = "total"
        case total_pages = "total_pages"
        case photos = "results"
    }
    
    func getPhotos() -> [UnsplashPhoto] {
        return self.photos
    }
    
    func convertPhotoListEntity(term: String, page: Int) -> PhotoListEntity {
        return PhotoListEntity(term: term, total_page: self.total_pages, page: page, photos: photos.compactMap { return $0.convertPhotoEntity() })
    }
}

struct UnsplashPhoto: Codable {
    var id: String
    var artist: UnsplashPhotoArtist
    var width: Int
    var height: Int
    var urls: UnsplashPhotoURL
    var sponsorship: UnsplashPhotosponsorship?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case artist = "user"
        case width = "width"
        case height = "height"
        case urls = "urls"
        case sponsorship = "sponsorship"
    }
    
    func convertPhotoEntity() -> PhotoEntity {
        return PhotoEntity(artistName: self.artist.name, imageUrl: self.urls.small, isSponsorship: self.sponsorship != nil, width: self.width, height: self.height)
    }
}

struct UnsplashPhotoArtist: Codable {
    var id: String
    var name: String
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}

struct UnsplashPhotoURL: Codable {
    var regular: String
    var small: String
    enum CodingKeys: String, CodingKey {
        case regular = "regular"
        case small = "small"
    }
}

struct UnsplashPhotosponsorship: Codable {
    var tagline: String
    enum CodingKeys: String, CodingKey {
        case tagline = "tagline"
    }
}
