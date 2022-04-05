//
//  CommonContext.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/01.
//

import Foundation

protocol CommonApplicationContextInterface: ApplicationContextInterface {
    func configure()
    func register<T>(_ assemble: @escaping () -> T)
    func register<T>(key: String, _ assemble: @escaping () -> T)
    func registerSingleton<T>(_ assemble: @escaping () -> T)
    func registerSingleton<T>(key: String, _ assemble: @escaping () -> T)
}


class CommonApplicationContext: CommonApplicationContextInterface {
    private(set) var factory = Assembler()
    private(set) var singletonMap = Dictionary<String, Any>()
    init() {
         configure()
    }

    func resolve<T>() -> T {
        Logger.track()
        let key = String(describing: T.self)
        guard let object = singletonMap[key] as? T else {
            return factory.resolve() as T
        }
        return object
    }

    func resolve<T>(key: String) -> T {
        Logger.track()
        guard let object = singletonMap[key] as? T else {
            return factory.resolve(key: key)
        }
        return object
    }

    func configure() {
        Logger.track()

    }
    
    func register<T>(_ assemble: @escaping () -> T) {
        Logger.track()
        factory.register(assemble)
    }
    
    func register<T>(key: String, _ assemble: @escaping () -> T) {
        Logger.track()
        factory.register(key: key, assemble)
    }
    
    func registerSingleton<T>(_ assemble: @escaping () -> T) {
        Logger.track()
        self.register(assemble)
        let key = String(describing: T.self)
        singletonMap[key] = factory.resolve(key: key) as T
        Logger.track("singltonmap: \(singletonMap)")

    }

    func registerSingleton<T>(key: String, _ assemble: @escaping () -> T) {
        Logger.track()
        self.register(key: key, assemble)
        singletonMap[key] = factory.resolve(key: key) as T
    }
}
