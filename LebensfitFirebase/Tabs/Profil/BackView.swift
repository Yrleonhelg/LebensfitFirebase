//
//  BackView.swift
//  LebensfitFirebase
//
//  Created by Leon on 14.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

class BackView: UIImageView {
    
    var thisframe: CGRect
    var anImage: UIImage? {
        didSet {
            setupImage()
        }
    }
    
    override init(frame: CGRect) {
        self.thisframe = frame
        super.init(frame: .zero)
        self.anImage = UIImage(named: "gray")
        //setupImage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupImage() {
        self.image = anImage
        self.addSubview(blurry)
        self.addSubview(blacky)
        self.layer.insertSublayer(gradientLayer, at: 1)
        print(gradientLayer.bounds)
    }
    
    lazy var blurry: UIVisualEffectView = {
        let blur = UIVisualEffectView()
        blur.effect = UIBlurEffect(style: .regular)
        blur.frame = (thisframe)
        return blur
    }()
    
    lazy var blacky: UIImageView = {
        let black = UIImageView()
        black.backgroundColor = .black
        black.alpha = 0.5
        black.frame = (thisframe)
        return black
    }()
    
    lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.black.withAlphaComponent(0.0).cgColor,
                           UIColor.black.withAlphaComponent(1.0).cgColor]
        gradient.frame = (thisframe)
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        return gradient
    }()
    
    //MARK: - Properties & Variables
    var lastURLUsedToLoadImage: String?
    
    //MARK: - Methods
    func loadImage(urlString: String) {
        lastURLUsedToLoadImage = urlString
        
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err { print("Failed to fetch post image:", err); return }
            if url.absoluteString != self.lastURLUsedToLoadImage { return }
            
            guard let imageData = data else { return }
            let photoImage = UIImage(data: imageData)
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                
                self.anImage = photoImage
            }
            }.resume()
    }
}

