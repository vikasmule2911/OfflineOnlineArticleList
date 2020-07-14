//
//  ImageView+Extension.swift
//  Jet2Articles
//
//  Created by Vikas Mule on 10/07/20.
//  Copyright © 2020 Vikas Mule. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

// MARK: - UIImageView extension
extension UIImageView {
    
    /// This loadThumbnail function is used to download thumbnail image using urlString
    /// This method also using cache of loaded thumbnail using urlString as a key of cached thumbnail.
    func loadThumbnail(urlSting: String) {
        guard let url = URL(string: urlSting) else { return }
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlSting as AnyObject) {
            image = imageFromCache as? UIImage
            return
        }
        
        NetworkManager().downloadImage(url: url) { [weak self] result, error in
            guard let self = self else { return }
            if let imageData = result {
                guard let imageToCache = UIImage(data: imageData) else { return }
                imageCache.setObject(imageToCache, forKey: urlSting as AnyObject)
                self.image = imageToCache
            } else {
                self.image = UIImage(named: "jet2_logo")
            }
        }
    }
}
