//
//  PinnCell.swift
//  LebensfitFirebase
//
//  Created by Leon on 28.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit
import Firebase

class PinnCell: UITableViewCell, ReusableView {
    //MARK: - Properties & Variables
    var user: User? {
        didSet {
            guard let profileImageUrl   = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: profileImageUrl)
        }
    }
    //MARK: - GUI Objects
    
    let profileImageView: CustomImageView = {
        let customview              = CustomImageView()
        customview.contentMode      = .scaleAspectFill
        customview.clipsToBounds    = true
        return customview
    }()
    
    let messagePreview: UILabel = {
        let label   = UILabel()
        label.text  = "Dieser Nutzer ist..."
        label.font  = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 2
        return label
    }()
    
    let chevronLabel: UILabel = {
        let label       = UILabel()
        label.textColor = .black
        label.text      = "›"
        label.font      = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    
    //MARK: - Init & View Loading
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        setupViews()
    }
    
    //MARK: - Setup
    func setupViews() {
        addSubview(profileImageView)
        addSubview(messagePreview)
        addSubview(chevronLabel)
    }
    
    //called from rowforsection to provide the correct info from the start
    func confBounds(){
        let frameHeight = self.frame.height
        let pictureHeight = frameHeight - 10
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: pictureHeight, height: pictureHeight)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = pictureHeight / 2
        
        chevronLabel.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        chevronLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        messagePreview.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: chevronLabel.leftAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
