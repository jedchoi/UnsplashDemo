//
//  Error.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/01.
//

import Foundation

class TraceError: Error {
    public let message: String
    public let code: String
    
    public init(message: String = "", code: String = "") {
        self.message = message
        self.code = code
    }
    
    public init(error: Error?) {
        self.message = error?.localizedDescription ?? ""
        self.code = ""
    }
}
