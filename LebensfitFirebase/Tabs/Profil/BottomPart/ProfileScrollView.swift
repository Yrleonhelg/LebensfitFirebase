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
    
    var heightOfContent = NSLayoutConstraint()
    var heightOfPinnwandView = NSLayoutConstraint()
    var heightOfSteckbriefView = NSLayoutConstraint()
    
    var heightOfAllPaddings: CGFloat    = 0
    
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
    }
    
    //MARK: - Setup
    func setupViews() {
        addSubview(contentView)
        heightOfContent = contentView.heightAnchor.constraint(equalToConstant: 0)
        heightOfContent.isActive = true
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(controlStackView)
        contentView.addSubview(dividerView)
        contentView.addSubview(segmentedController)
        segmentedController.addTarget(self, action: #selector(changeView(sender:)), for: .valueChanged)
        
        contentView.addSubview(pinnwandView)
        contentView.addSubview(steckbriefView)
        heightOfPinnwandView = pinnwandView.heightAnchor.constraint(equalToConstant: 0)
        heightOfSteckbriefView = steckbriefView.heightAnchor.constraint(equalToConstant: 0)
        heightOfPinnwandView.isActive = true
        heightOfSteckbriefView.isActive = true
    }
    
    func confBounds(){
        guard let parent = parentVC else { return }
        heightOfAllPaddings = 0
        contentView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        contentView.widthAnchor.constraint(equalTo: self.frameLayoutGuide.widthAnchor, multiplier: 1).isActive = true
        
        profileImageView.anchor(top: contentView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 250, height: 250)
        profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        profileImageView.layer.cornerRadius = 250/2
        heightOfAllPaddings += 20
        
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        usernameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        heightOfAllPaddings += 10
        
        if parent.userId != Auth.auth().currentUser?.uid { //TODO: with the height
            contentView.addSubview(followButton)
            followButton.anchor(top: usernameLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 160, height: 40)
            followButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
            controlStackView.anchor(top: followButton.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 15, paddingLeft: -10, paddingBottom: 0, paddingRight: -10, width: 0, height: 80)
            heightOfAllPaddings += 45
        } else {
            controlStackView.anchor(top: usernameLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: -10, paddingBottom: 0, paddingRight: -10, width: 0, height: 80)
            heightOfAllPaddings += 20
        }
        dividerView.anchor(top: controlStackView.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: -10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        heightOfAllPaddings -= 10
        
        segmentedController.anchor(top: dividerView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        heightOfAllPaddings += 10
        
        steckbriefView.anchor(top: segmentedController.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        pinnwandView.anchor(top: segmentedController.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        heightOfSteckbriefView.constant = 300
        heightOfPinnwandView.constant = 0
    }
    
    //MARK: - Methods
    func calculateHeightOfAllObjects() -> CGFloat{
        let uiArray: [UIView] = [profileImageView, usernameLabel, followButton, controlStackView, dividerView, segmentedController, steckbriefView, pinnwandView]
        let sum = uiArray.reduce(0, {$0 + $1.frame.height})
        return sum + heightOfAllPaddings + 50
    }
    
    
    @objc func changeView(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            presentPinnwandView()
        default:
            presentSteckbriefView()
        }
    }
    
    func presentSteckbriefView() {
        pinnwandView.setHeightToZero()
        heightOfPinnwandView.constant = 0
        heightOfSteckbriefView.constant = 300
        steckbriefView.resetHeight()
    }
    
    func presentPinnwandView() {
        steckbriefView.setHeightToZero()
        heightOfSteckbriefView.constant = 0
        heightOfPinnwandView.constant = 300
        pinnwandView.resetHeight()
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
