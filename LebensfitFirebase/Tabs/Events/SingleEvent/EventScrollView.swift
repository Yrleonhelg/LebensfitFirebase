//
//  EventScrollView.swift
//  LebensfitFirebase
//
//  Created by Leon on 21.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit
import MapKit

@objc protocol scrollViewToSingleEvent: Any {
    func getStringFromLocation(location: CLLocationCoordinate2D) -> String
    @objc func openInGoogleMaps()
    func viewDidLayoutSubviews()
    func getSingleEventVC() -> SingleEventViewController
}

class EventScrollView: UIScrollView {
    
    //MARK: - Properties & Variables
    var delegateSVToSingleEvent: scrollViewToSingleEvent?
    let thisEvent:              Event
    var tableViewControllers:   [PeopleTableView]!
    var tableViews:             [UITableView]!
    
    let padding: CGFloat                = 20
    var heightOfAllPaddings: CGFloat    = 0
    var heightCons                      = [NSLayoutConstraint]()
    var heightOfContent                 = NSLayoutConstraint()
    
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
    
    let surePeopleTV: SurePeople!
    let maybePeopleTV: MaybePeople!
    let nopePeopleTV: NopePeople!
    
    //MARK: - Init & View Loading
    init(frame: CGRect, event: Event) {
        self.thisEvent = event
        surePeopleTV = SurePeople(frame: frame, event: event)
        maybePeopleTV = MaybePeople(frame: frame, event: event)
        nopePeopleTV = NopePeople(frame: frame, event: event)
        super.init(frame: frame)
        self.backgroundColor = LebensfitSettings.Colors.basicBackColor
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
        titleLabel.text = thisEvent.eventName
        notesContentLabel.text  = thisEvent.eventDescription
        if let start = thisEvent.eventStartingDate, let finish = thisEvent.eventFinishingDate {
            timeLabel.text = "Von \(start.getHourAndMinuteAsStringFromDate()) bis \(finish.getHourAndMinuteAsStringFromDate())"
        }
        if let location = thisEvent.eventLocation {
            locationLabel.text  = delegateSVToSingleEvent?.getStringFromLocation(location: location as! CLLocationCoordinate2D)
        }
        if let date = thisEvent.eventStartingDate {
            dateLabel.text = (date as Date).formatDateEEEEddMMMyyyy()
        }
    }
    
    func setupViews() {
        let locationTap = UITapGestureRecognizer(target: delegateSVToSingleEvent, action: #selector(delegateSVToSingleEvent?.openInGoogleMaps))
        locationTap.cancelsTouchesInView = false
        locationTap.numberOfTapsRequired = 1
        
        addSubview(contentView)
        heightOfContent = contentView.heightAnchor.constraint(equalToConstant: 0)
        heightOfContent.isActive = true
        
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
            controller.delegateTVToSingleEvent = delegateSVToSingleEvent?.getSingleEventVC()
            controller.delegateTVToScrollView = self
            let heightCon = controller.heightAnchor.constraint(equalToConstant: 0)
            heightCon.isActive = true
            heightCons.append(heightCon)
        }
    }
    
    
    func confBounds(){
        contentView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        contentView.widthAnchor.constraint(equalTo: self.frameLayoutGuide.widthAnchor, multiplier: 1).isActive = true
        
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
    func calculateHeightOfAllObjects() -> CGFloat{
        let uiArray: [UIView] = [titleLabel, locationLabel, dateLabel, timeLabel, mapView, notesHeaderLabel, notesContentLabel, surePeopleTV, maybePeopleTV, nopePeopleTV]
        let sum = uiArray.reduce(0, {$0 + $1.frame.height})
        return sum + heightOfAllPaddings
    }
    
    func reloadAllTableViews() {
        tableViewControllers.forEach { (controller) in
            controller.loadUsers()
        }
        tableViews.forEach { (tableview) in
            DispatchQueue.main.async( execute: {
                tableview.reloadData()
            })
        }
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EventScrollView: tableViewToScrollView {
    func finishedLoadingParticipants() {
        if surePeopleTV.finishedLoading == true && maybePeopleTV.finishedLoading == true && nopePeopleTV.finishedLoading == true {
            for (index, controller) in tableViewControllers.enumerated() {
                var height = CGFloat(controller.users.count) * 60.0
                print(index, "Users: ",controller.users.count)
                if controller.users.count > 0 {
                    height += controller.padding
                    heightCons[index].constant = height
                    controller.confBounds()
                } else {
                    heightCons[index].constant = 0
                }
                controller.finishedLoading = false
                layoutIfNeeded()
                delegateSVToSingleEvent?.viewDidLayoutSubviews()
            }
        }
    }
}
