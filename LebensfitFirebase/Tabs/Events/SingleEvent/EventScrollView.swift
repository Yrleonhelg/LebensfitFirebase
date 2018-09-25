//
//  EventScrollView.swift
//  LebensfitFirebase
//
//  Created by Leon on 21.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

class EventScrollView: UIScrollView, UIGestureRecognizerDelegate {
    
    //MARK: - Properties & Variables
    var parentVC: SingleEventViewController?
    
    let padding: CGFloat = 20
    var heightOfAllPaddings: CGFloat = 0
    
    var tableViewControllers: [PeopleTableView]!
    var tableViews: [UITableView]!
    var heightCons = [NSLayoutConstraint]()
    
    //MARK: - GUI Objects
    let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let titleLabel: UILabel = {
        let label       = UILabel()
        label.font      = UIFont.boldSystemFont(ofSize: 25)
        label.text      = "Titel"
        label.textColor = .black
        return label
    }()
    
    let locationLabel: UILabel = {
        let label           = UILabel()
        label.font          = UIFont.systemFont(ofSize: 16)
        label.text          = "Standort"
        label.textColor     = LebensfitSettings.Colors.basicTintColor
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let dateLabel: UILabel = {
        let label       = UILabel()
        label.font      = UIFont.systemFont(ofSize: 16)
        label.text      = "1. Jan. 2018"
        label.textColor = .gray
        return label
    }()
    let timeLabel: UILabel = {
        let label       = UILabel()
        label.font      = UIFont.systemFont(ofSize: 16)
        label.text      = "Von jetzt bis jetzt"
        label.textColor = .gray
        return label
    }()
    
    let mapView: UIImageView = {
        let view                = UIImageView()
        view.clipsToBounds      = true
        view.layer.cornerRadius = 10
        view.contentMode        = .scaleAspectFill
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let notesHeaderLabel: UILabel = {
        let label       = UILabel()
        label.font      = UIFont.systemFont(ofSize: 20)
        label.text      = "Notizen"
        label.textColor = .black
        return label
    }()
    let notesContentLabel: UILabel = {
        let label           = UILabel()
        label.font          = UIFont.systemFont(ofSize: 16)
        label.text          = "Beschreibung"
        label.textColor     = .gray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let surePeopleTV: SurePeople = {
        let view = SurePeople()
        return view
    }()
    let maybePeopleTV: MaybePeople = {
        let view = MaybePeople()
        return view
    }()
    let nopePeopleTV: NopePeople = {
        let view = NopePeople()
        return view
    }()
    
    //MARK: - Init & View Loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = LebensfitSettings.Colors.basicBackColor
        
        self.isUserInteractionEnabled = true
        contentView.isUserInteractionEnabled = true
        self.panGestureRecognizer.isEnabled = false
    }
    
    func setupTheSetup() {
        tableViewControllers    = [surePeopleTV, maybePeopleTV, nopePeopleTV]
        tableViews              = [surePeopleTV.peopleTableView, maybePeopleTV.peopleTableView, nopePeopleTV.peopleTableView]
        applyDefaultValues()
        setupViews()
    }
    
    func viewDidAppear() {
        confBounds()
        for controller in tableViewControllers {
            controller.loadUsers()
        }
    }
    
    //MARK: - Setup
    func applyDefaultValues() {
        guard let parent = parentVC else { return }
        titleLabel.text = parent.eventName
        notesContentLabel.text  = parent.eventDescription
        if let start = parent.eventStartingDate, let finish = parent.eventFinishingDate {
            timeLabel.text = "Von \(start.getHourAndMinuteAsStringFromDate()) bis \(finish.getHourAndMinuteAsStringFromDate())"
        }
        
        if let location = parent.eventLocation {
            locationLabel.text  = parent.getStringFromLocation(location: location)
        }
        if let date = parent.eventStartingDate {
            dateLabel.text = (date as Date).formatDateEEEEddMMMyyyy()
        }
    }
    
    @objc func tapped() {
        print("tapped")
    }
    
    func setupViews() {
        guard let parent = parentVC else { return }
        let locationTap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        locationTap.cancelsTouchesInView = false
        locationTap.numberOfTapsRequired = 1
        locationTap.delegate = self

        addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(mapView)
        contentView.addSubview(notesHeaderLabel)
        contentView.addSubview(notesContentLabel)
        locationLabel.addGestureRecognizer(locationTap)
        mapView.addGestureRecognizer(locationTap)
        
        for controller in tableViewControllers {
            contentView.addSubview(controller)
            controller.parentVC = parent
            controller.parentSV = self
            let heightCon = controller.heightAnchor.constraint(equalToConstant: 0)
            heightCon.isActive = true
            heightCons.append(heightCon)
        }
    }
    
    func confBounds(){
        contentView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        contentView.widthAnchor.constraint(equalTo: self.frameLayoutGuide.widthAnchor, multiplier: 1).isActive = true
        contentView.heightAnchor.constraint(equalTo: self.frameLayoutGuide.heightAnchor, multiplier: 1).isActive = true
        
        titleLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
        locationLabel.anchor(top: titleLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: padding, paddingBottom: 0, paddingRight: 0, width: 200, height: 0)
        heightOfAllPaddings += 10
        
        dateLabel.anchor(top: titleLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 50, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
        timeLabel.anchor(top: dateLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
        heightOfAllPaddings += 50
        
        mapView.anchor(top: timeLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 200)
        heightOfAllPaddings += padding
        
        notesHeaderLabel.anchor(top: mapView.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
        notesContentLabel.anchor(top: notesHeaderLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 5, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
        heightOfAllPaddings += 20 + 5
        
        surePeopleTV.anchor(top: notesContentLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
        maybePeopleTV.anchor(top: surePeopleTV.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
        nopePeopleTV.anchor(top: maybePeopleTV.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
    }
    
    //MARK: - Methods
    func calculateHeightOfAllObjects() -> CGFloat {
        var heightOfAllObjects: CGFloat = 0
        heightOfAllObjects += titleLabel.frame.height + locationLabel.frame.height
        heightOfAllObjects += dateLabel.frame.height + timeLabel.frame.height
        heightOfAllObjects += mapView.frame.height
        heightOfAllObjects += notesHeaderLabel.frame.height + notesContentLabel.frame.height
        
        for controller in tableViewControllers {
            var height = CGFloat(controller.users.count) * controller.height
            if controller.users.count > 0 {
                height += controller.padding
            }
            heightOfAllObjects += height
        }
        heightOfAllObjects += 12
        
        guard let parent = parentVC else { return heightOfAllObjects }
        heightOfAllObjects -= parent.participateButton.frame.height
        return heightOfAllObjects
    }
    
    func finishedLoadingParticipants() {
        if surePeopleTV.finishedLoading == true && maybePeopleTV.finishedLoading == true && nopePeopleTV.finishedLoading == true {
            for (index, controller) in tableViewControllers.enumerated() {
                var height = CGFloat(controller.users.count) * 60.0
                print("Users: ",controller.users.count)
                if controller.users.count > 0 {
                    height += controller.padding
                    heightCons[index].constant = height
                    controller.confBounds()
                } else {
                    heightCons[index].constant = 0
                }
                layoutIfNeeded()
                parentVC?.viewDidLayoutSubviews()
            }
        }
    }
    
    func reloadAllTableViews() {
        print("Function: \(#function)")
        for controller in tableViewControllers {
            controller.finishedLoading = false
            controller.loadUsers()
        }
        for tv in tableViews {
            DispatchQueue.main.async( execute: {
                tv.reloadData()
            })
        }
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
