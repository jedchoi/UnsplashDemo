//
//  UnsplashDemoTests.swift
//  UnsplashDemoTests
//
//  Created by JaeHyuk Choi on 2022/04/05.
//

import XCTest
import Combine
@testable import UnsplashDemo

class UnsplashDemoTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testFakeUnsplashAPIDataSourceGetImage() throws {
        let expt = expectation(description: "Test get image list from fake data source")
        let datasource = FakeUnsplashAPIDataSource()
        var cancelBag = Set<AnyCancellable>()
        datasource.getPhotoList(page: 1).sink { result in
            switch result {
            case .finished:
                Logger.track("finished") // 2. "finished"
            case .failure(let error):
                Logger.track(error.localizedDescription)
            }
        } receiveValue: { value in
            XCTAssert(!value.photos.isEmpty, "test failed")
            expt.fulfill()
            Logger.track("\(value)")
        }.store(in: &cancelBag)
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testFakeUnsplashAPIDataSourceSearchImage() throws {
        let expt = expectation(description: "Test get image list from fake data source")
        let datasource = FakeUnsplashAPIDataSource()
        var cancelBag = Set<AnyCancellable>()
        datasource.searchPhotos(page: 1, term: "mountain").sink { result in
            switch result {
            case .finished:
                Logger.track("finished") // 2. "finished"
            case .failure(let error):
                Logger.track(error.localizedDescription)
            }
        } receiveValue: { value in
            XCTAssert(!value.photos.isEmpty, "test failed")
            expt.fulfill()
            Logger.track("\(value)")
        }.store(in: &cancelBag)
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testDataTaskPublisher() throws {
        let expt = expectation(description: "Test dataTaskPublisher api using url from data source")
        let datasource = UnsplashAPIDataSource()
        let url = datasource.getURL(type: .list_photo, page: 1)
        var cancelBag = Set<AnyCancellable>()
        URLSession.shared.dataTaskPublisher(for: url)
            .print()
            .map(\.data)
            .replaceError(with: Data())
            .sink(receiveCompletion: { result in
                Logger.track("result:\(result)")
            }, receiveValue: { val in
                let str = String(data: val, encoding: .utf8) ?? ""
                Logger.track("val: \(str)")
                XCTAssert(!str.isEmpty, "test failed")
                expt.fulfill()
            }).store(in: &cancelBag)
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testUnsplashAPIDataSourceGetImage() throws {
        let expt = expectation(description: "Test get image list from data source")
        let datasource = UnsplashAPIDataSource()
        var cancelBag = Set<AnyCancellable>()
        datasource.getPhotoList(page: 1).sink { result in
            switch result {
            case .finished:
                Logger.track("finished") // 2. "finished"
            case .failure(let error):
                Logger.track(error.localizedDescription)
            }
        } receiveValue: { value in
            XCTAssert(!value.photos.isEmpty, "test failed")
            expt.fulfill()
            Logger.track("\(value)")
        }.store(in: &cancelBag)
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    func testUnsplashAPIDataSourceSearchImage() throws {
        let expt = expectation(description: "Test search image list from data source")
        let datasource = UnsplashAPIDataSource()
        var cancelBag = Set<AnyCancellable>()
        datasource.searchPhotos(page: 1, term: "mountain").sink { result in
            switch result {
            case .finished:
                Logger.track("finished") // 2. "finished"
            case .failure(let error):
                Logger.track(error.localizedDescription)
            }
        } receiveValue: { value in
            XCTAssert(!value.photos.isEmpty, "test failed")
            expt.fulfill()
            Logger.track("\(value)")
        }.store(in: &cancelBag)
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testGetImageUseCase() throws {
        ApplicationContext.initialize(.prod)
        let expt = expectation(description: "Test get image list use case")
        let usecase = GetPhotoListUseCase()
        var cancelBag = Set<AnyCancellable>()
        usecase.execute(param: 1).sink { result in
            switch result {
            case .finished:
                Logger.track("finished") // 2. "finished"
            case .failure(let error):
                Logger.track(error.localizedDescription)
            }
        } receiveValue: { value in
            XCTAssert(!value.photos.isEmpty, "test failed")
            expt.fulfill()
            Logger.track("\(value)")
        }.store(in: &cancelBag)
        ApplicationContext.destroy()
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testSearchPhotosUseCase() throws {
        ApplicationContext.initialize(.prod)
        let expt = expectation(description: "Test search image list use case")
        let usecase = SearchPhotosUseCase()
        var cancelBag = Set<AnyCancellable>()
        let param = SearchPhotoInputParam(term: "mountain", page: 1)
        usecase.execute(param: param).sink { result in
            switch result {
            case .finished:
                Logger.track("finished") // 2. "finished"
            case .failure(let error):
                Logger.track(error.localizedDescription)
            }
        } receiveValue: { value in
            XCTAssert(!value.photos.isEmpty, "test failed")
            expt.fulfill()
            Logger.track("\(value)")
        }.store(in: &cancelBag)
        ApplicationContext.destroy()
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
