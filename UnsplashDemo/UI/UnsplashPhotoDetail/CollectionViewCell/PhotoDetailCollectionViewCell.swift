//
//  PhotoDetailCollectionViewCell.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/03.
//

import Foundation

import UIKit
import Foundation

class PhotoDetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photo: UIImageView!
    func configureCell(photoInfo: PhotoEntity) {
        Logger.track()
        photo.loadRemoteImageFrom(from: photoInfo.imageUrl)
    }
}
