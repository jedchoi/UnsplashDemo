//
//  ApplicationContext.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/01.
//

import Foundation

class ApplicationContext  {
    private static var soleInstance: ApplicationContextInterface?
    
    
    static private func getInstance() -> ApplicationContextInterface {
        guard let soleInstance = self.soleInstance else {
            Logger.track("ApplicationContext is not initialized")
            return ProdApplicationContext()
        }
        
        return soleInstance
    }
    
    static func initialize(_ source: ApplicationContextType = .prod) {
        Logger.track()
        soleInstance = source.initialize()
    }
    
    static func destroy() {
        Logger.track()
        soleInstance = nil
    }
    
    static func getObject<T>(key: String) -> T {
        Logger.track()
        return getInstance().resolve(key: key)
    }
    
    static func resolve<T>() -> T {
        Logger.track()
        return getInstance().resolve()
    }
}

enum ApplicationContextType {
    case prod
    case test
    
    func initialize() -> ApplicationContextInterface {
        switch self {
        case .prod:
            return ProdApplicationContext()
        case .test:
            return TestApplicationContext()
        }
    }
}

protocol ApplicationContextInterface {
    func resolve<T>() -> T
    func resolve<T>(key: String) -> T
}
