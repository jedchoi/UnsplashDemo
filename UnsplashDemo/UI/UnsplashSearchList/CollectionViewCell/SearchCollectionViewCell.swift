//
//  SearchCollectionViewCell.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/03.
//

import UIKit
import Foundation

class SearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var sponsored: UILabel!
    func configureCell(photoInfo: PhotoEntity) {
        Logger.track()
        photo.loadRemoteImageFrom(from: photoInfo.imageUrl)
        artist.text = photoInfo.artistName
        sponsored.isHidden = !photoInfo.isSponsorship
    }
}
