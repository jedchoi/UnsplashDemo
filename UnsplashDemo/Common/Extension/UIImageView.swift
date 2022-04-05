//
//  UIImageView.swift
//  TestCollectionView
//
//  Created by JaeHyuk Choi on 2022/04/02.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {    
    func loadRemoteImageFrom(from urlString: String){
        let url = URL(string: urlString)
        image = nil
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        image = UIImage(named: "blur")
        URLSession.shared.dataTask(with: url!) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else { return }
            imageCache.setObject(image, forKey: urlString as AnyObject)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.image = image
            }
         }.resume()
    }
}
