//
//  Logger.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/01.
//

import Foundation

class Logger {
    static func track(_ message: String = ".", file: String = #file, function: String = #function, line: Int = #line) {
        let date = DateFormatter()
        date.dateFormat = "HH:mm:ss.SSS"
        var filename = file.split(separator: "/").last?.split(separator: ".").first ?? ""
        
        var functionName = function.split(separator: "(").first ?? ""
        for i in 0...30 {
            if filename.count <= i {
                filename.append(contentsOf: " ")
            }
            if functionName.count <= i-10 {
                functionName.append(contentsOf: " ")
            }
        }
        print("\(date.string(from: Date()))\t[Unsplash Test] \t\(filename)\t \(functionName)\t\t\(message)")
    }
}
