//
//  UIView.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/05.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
