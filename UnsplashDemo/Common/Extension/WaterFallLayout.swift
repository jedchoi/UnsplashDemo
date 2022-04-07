//
//  WaterFallLayout.swift
//  UnsplashDemo
//
//  Created by JaeHyuk Choi on 2022/04/07.
//

import Foundation
import UIKit

class WaterFallLayout: UICollectionViewFlowLayout {
    var attributeArray: Array<UICollectionViewLayoutAttributes>?
    var photos: [PhotoEntity] = []

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init() {
        super.init()
    }

    override func prepare() {
        super.prepare()
        self.scrollDirection = .vertical
        attributeArray = Array<UICollectionViewLayoutAttributes>()
        let lineSpace = CGFloat(self.minimumLineSpacing)
        let itemSpace = CGFloat(self.minimumInteritemSpacing)
        let cellWidth = (UIScreen.main.bounds.size.width - itemSpace) / 2
        var queueHieght: (first: Int, second: Int) = (0, 0)

        for index in 0 ..< self.photos.count {
            let indexPath = IndexPath(item: index, section: 0)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let cellHeight = cellWidth * CGFloat(photos[index].getHeightRatio())

            if queueHieght.first <= queueHieght.second {
                let cellYPosition = CGFloat(queueHieght.first)
                queueHieght.first += Int(cellHeight + lineSpace)
                attribute.frame = CGRect(x: 0, y: cellYPosition, width: cellWidth, height: cellHeight)
            } else {
                let cellYPosition = CGFloat(queueHieght.second)
                queueHieght.second += Int(cellHeight + lineSpace)
                attribute.frame = CGRect(x: itemSpace + cellWidth, y: cellYPosition, width: cellWidth, height: cellHeight)
            }
            attributeArray?.append(attribute)
        }

        if photos.count > 0 {
            let height = queueHieght.first >= queueHieght.second ? queueHieght.first : queueHieght.second
            self.itemSize = CGSize(width: cellWidth, height: CGFloat(height * 2 / photos.count) - lineSpace)
        }
    }

    func update(photos: [PhotoEntity]) {
        self.photos = photos
        prepare()
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributeArray
    }
}
