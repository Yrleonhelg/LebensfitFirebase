//
//  BackView.swift
//  LebensfitFirebase
//
//  Created by Leon on 14.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

class BackView: CustomImageView {
    
    var thisframe: CGRect
    var whiteValue: CGFloat
    var blackValue: CGFloat
    
    override var image: UIImage? {
        didSet {
            setupImage()
        }
    }
    
    init(frame: CGRect, white: CGFloat, black: CGFloat) {
        self.thisframe = frame
        self.whiteValue = white
        self.blackValue = black
        super.init(frame: .zero)
        self.image = UIImage(named: "blue")
        self.backgroundColor = .green
        setupImage()
    }
    
    func setupImage() {
        normal.image = image
        self.addSubview(normal)
        self.addSubview(blurry)
        if whiteValue > 0.0 {
            self.addSubview(whitey)
        }
        if blackValue > 0.0 {
            self.addSubview(blacky)
        }
        gradientLayer.removeFromSuperlayer()
        self.layer.insertSublayer(gradientLayer, at: 4)
    }
    lazy var normal: UIImageView = {
        let view = UIImageView()
        view.image = image
        view.frame = thisframe
        return view
    }()
    
    lazy var blurry: UIVisualEffectView = {
        let blur = UIVisualEffectView()
        blur.effect = UIBlurEffect(style: .regular)
        blur.frame = (thisframe)
        return blur
    }()
    
    lazy var blacky: UIImageView = {
        let black = UIImageView()
        black.backgroundColor = .black
        black.alpha = blackValue
        black.frame = (thisframe)
        return black
    }()
    
    lazy var whitey: UIImageView = {
        let white = UIImageView()
        white.backgroundColor = .white
        white.alpha = whiteValue
        white.frame = (thisframe)
        return white
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
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

