//
//  ProfileScrollView.swift
//  LebensfitFirebase
//
//  Created by Leon on 25.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit
import Firebase

class ProfileScrollView: UIScrollView {
    //MARK: - Properties & Variables
    var parentVC: ProfileController?
    
    //MARK: - GUI Objects
    let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let profileImageView: CustomImageView = {
        let iv              = CustomImageView()
        iv.clipsToBounds    = true
        iv.contentMode      = .scaleAspectFill
        iv.image            = UIImage(named: "basePP")
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label           = UILabel()
        label.text          = "username"
        label.textColor     = LebensfitSettings.Colors.basicTextColor
        label.font          = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .left
        return label
    }()
    
    let followButton: UIButton = {
        let button                  = UIButton()
        button.setTitle("Folgen", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor      = LebensfitSettings.Colors.basicTintColor
        button.layer.cornerRadius   = 20
        return button
    }()
    
    let teilgenommeneKurseLabel: UILabel = {
        let label               = UILabel()
        label.textAlignment     = .center
        label.numberOfLines     = 0
        
        let attributedText      = NSMutableAttributedString(string: "2\n", attributes: [NSAttributedString.Key.foregroundColor: LebensfitSettings.Colors.basicTextColor, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)])
        attributedText.append(NSAttributedString(string: "Kurse", attributes: [NSAttributedString.Key.foregroundColor: LebensfitSettings.Colors.NITextColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]))
        label.attributedText    = attributedText
        return label
    }()
    
    let followerLabel: UILabel = {
        let label               = UILabel()
        label.textAlignment     = .center
        label.numberOfLines     = 0
        
        let attributedText      = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.foregroundColor: LebensfitSettings.Colors.basicTextColor, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)])
        attributedText.append(NSAttributedString(string: "Follower", attributes: [NSAttributedString.Key.foregroundColor: LebensfitSettings.Colors.NITextColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]))
        label.attributedText    = attributedText
        return label
    }()
    
    let videosLabel: UILabel = {
        let label               = UILabel()
        label.textAlignment     = .center
        label.numberOfLines     = 0
        
        let attributedText      = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.foregroundColor: LebensfitSettings.Colors.basicTextColor, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)])
        attributedText.append(NSAttributedString(string: "Videos", attributes: [NSAttributedString.Key.foregroundColor: LebensfitSettings.Colors.NITextColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]))
        label.attributedText    = attributedText
        return label
    }()
    
    lazy var controlStackView: UIStackView = {
        let sv          = UIStackView(arrangedSubviews: [teilgenommeneKurseLabel, followerLabel, videosLabel])
        sv.axis         = .horizontal
        sv.distribution = .fillEqually
        return sv
    }()
    
    let dividerView: UIView = {
        let dv              = UIView()
        dv.backgroundColor  = UIColor.lightGray
        return dv
    }()
    
    let segmentedController: UISegmentedControl = {
        let items               = ["Steckbrief", "Pinnwand"]
        let frame               = UIScreen.main.bounds
        
        let sc                  = UISegmentedControl(items: items)
        sc.selectedSegmentIndex = 0
        sc.frame                = CGRect(x: frame.minX + 10, y: frame.minY + 50, width: frame.width - 20, height: 30)
        sc.layer.cornerRadius   = 5.0
        sc.tintColor            = LebensfitSettings.Colors.basicTintColor
        return sc
    }()
    
    let steckbriefView: SteckbriefView = {
        let view = SteckbriefView()
        return view
    }()
    
    let pinnwandView: PinnwandView = {
        let view = PinnwandView()
        return view
    }()
    
    //MARK: - Init & View Loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        confBounds()
    }
    
    //MARK: - Setup
    func setupViews() {
        addSubview(contentView)
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(controlStackView)
        contentView.addSubview(dividerView)
        contentView.addSubview(segmentedController)
        segmentedController.addTarget(self, action: #selector(changeView(sender:)), for: .valueChanged)
    }
    
    func confBounds(){
        guard let parent = parentVC else { return }
        contentView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        contentView.widthAnchor.constraint(equalTo: self.frameLayoutGuide.widthAnchor, multiplier: 1).isActive = true
        contentView.heightAnchor.constraint(equalTo: self.frameLayoutGuide.heightAnchor, multiplier: 1).isActive = true
        
        profileImageView.anchor(top: contentView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 75, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 250, height: 250)
        profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        profileImageView.layer.cornerRadius = 250/2
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        usernameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        if parent.userId != Auth.auth().currentUser?.uid {
            contentView.addSubview(followButton)
            followButton.anchor(top: usernameLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 160, height: 40)
            followButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
            controlStackView.anchor(top: followButton.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 15, paddingLeft: -10, paddingBottom: 0, paddingRight: -10, width: 0, height: 80)
        } else {
            controlStackView.anchor(top: usernameLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 40, paddingLeft: -10, paddingBottom: 0, paddingRight: -10, width: 0, height: 80)
        }
        dividerView.anchor(top: controlStackView.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: -10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        segmentedController.anchor(top: dividerView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
    }
    
    //MARK: - Methods
    @objc func changeView(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            presentPinnwandView()
        default:
            presentSteckbriefView()
        }
    }
    
    func presentSteckbriefView() {
        removeSteckAndPinn()
        contentView.addSubview(steckbriefView)
        steckbriefView.anchor(top: segmentedController.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        steckbriefView.confBounds()
        steckbriefView.parentVC = parentVC
        steckbriefView.parentSV = self
    }
    
    func presentPinnwandView() {
        removeSteckAndPinn()
        contentView.addSubview(pinnwandView)
        pinnwandView.anchor(top: segmentedController.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        pinnwandView.confBounds()
        pinnwandView.parentVC = parentVC
        pinnwandView.parentSV = self
    }
    
    func removeSteckAndPinn() {
        steckbriefView.removeFromSuperview()
        pinnwandView.removeFromSuperview()
    }
    
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
