//
//  CustomImageView.swift
//  LebensfitFirebase
//
//  Created by Leon on 13.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()


class CustomImageView: UIImageView {
    //MARK: - Properties & Variables
    var lastURLUsedToLoadImage: String?
    
    //MARK: - Methods
    func loadImage(urlString: String, _ completion: ((Bool) -> ())? = nil) {
        lastURLUsedToLoadImage = urlString
        
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            if let comp = completion {
                comp(true)
            }
            return
        }
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err { print("Failed to fetch post image:", err); return }
            if url.absoluteString != self.lastURLUsedToLoadImage {
                if let comp = completion {
                    comp(true)
                }
                return
            }
            
            guard let imageData = data else { return }
            let photoImage = UIImage(data: imageData)
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                
                self.image = photoImage
                if let comp = completion {
                    comp(true)
                }
            }
            }.resume()
    }
}
