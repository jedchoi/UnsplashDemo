//
//  UnsplashAPIDataSource.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/01.
//

import Foundation
import Combine

enum UnsplashAPICommand {
    case list_photo
    case search_photo
    
    func getURLParameter(page: Int, term: String) -> Dictionary<String, String> {
        switch self {
        case .list_photo: 
            return ["page":String(page), "per_page":"10", "client_id":client_id]
        case .search_photo:
            return ["page":String(page), "per_page":"10", "client_id":client_id, "query":term]
        }
    }
    
    func getURLPath() -> String {
        switch self {
        case .list_photo:
            return "/photos"
        case .search_photo:
            return "/search/photos"
        }
    }
}

let client_id = "PllkaMOBBgGmOvi9QmLEhxLIK8VrIeu5KabdusmuHmU"

class UnsplashAPIDataSource: UnsplashAPIInterface {
    init() {
        Logger.track()
    }
    
    deinit {
        Logger.track()
    }
    
    func getPhotoList(page: Int) -> AnyPublisher<PhotoListEntity, TraceError> {
        Logger.track()
        return URLSession.shared.dataTaskPublisher(for: getURL(type: .list_photo, page: page))
            .print()
            .tryMap { data, response -> UnsplashSearchedData in
                guard let httpURLResponse = response as? HTTPURLResponse,
                   let total = httpURLResponse.value(forHTTPHeaderField: "x-total") else {
                       throw URLError(.dataLengthExceedsMaximum)
                    }
                Logger.track(total)
                guard let total = Int(total) else {
                    Logger.track("total convert int error")
                    throw TraceError(message: "total convert int error", code: "")
                }
                
                
                let decoder = JSONDecoder()
                guard let photos = try? decoder.decode([UnsplashPhoto].self, from: data) else {
                    throw TraceError(message: "photo parse error", code: "")
                }
                Logger.track("\(photos)")
                return UnsplashSearchedData(total_photos: total, total_pages: total/10, photos: photos)
//                return PhotoListEntity(total_page: total/10, page: page, photos: photos.map { $0.convertPhotoEntity() })
            }
            .map { $0.convertPhotoListEntity(term: "", page: page) }
            .mapError({ err in
                Logger.track("error!!!")
                return TraceError(error: err)
            })
            .eraseToAnyPublisher()
    }
    
    func searchPhotos(page: Int, term: String) -> AnyPublisher<PhotoListEntity, TraceError> {
        Logger.track()
        return URLSession.shared.dataTaskPublisher(for: getURL(type: .search_photo, page: page, term: term))
            .print()
            .map(\.data)
            .decode(type: UnsplashSearchedData.self, decoder: JSONDecoder())
            .tryMap { $0.convertPhotoListEntity(term: term, page: page) }
            .mapError({ err in
                TraceError(error: err)
            })
            .eraseToAnyPublisher()
    }

    func getURL(type: UnsplashAPICommand, page: Int, term: String = "") -> URL {
        Logger.track()
        
        var component = URLComponents()
        component.scheme = "https"
        component.host = "api.unsplash.com"
        component.path = type.getURLPath()
        component.queryItems = type.getURLParameter(page: page, term: term).map { (key: String, value: String) in
            URLQueryItem(name: key, value: value)
        }
        
        guard let url = component.url else {
            Logger.track("url error")
            return URL(fileURLWithPath: "")
        }
        Logger.track("url:\(url)")
        return url
    }
}
