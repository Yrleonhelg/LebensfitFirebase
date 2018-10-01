//
//  EventViewController.swift
//  LebensfitFirebase
//
//  Created by Leon on 10.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit
import MapKit
import Firebase

enum participateLists {
    case sure
    case maybe
    case nope
}


class SingleEventViewController: UIViewController {
    //MARK: - Properties & Variables
    var thisEvent: Event
    var eventName: String?
    var eventDescription: String?
    var eventLocation: CLLocationCoordinate2D?
    var eventStartingDate: NSDate?
    var eventFinishingDate: NSDate?
    var eventNeedsApplication: Bool?
    
    var snapShotter = MKMapSnapshotter()
    
    
    //MARK: - GUI Objects
    var scrollView = EventScrollView()
    var participateButtonStackView: ParticipateButtonStackView?
    
    //divides the buttons from the rest of the view
    let dividerButtonsView: UIView = {
        let view             = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    let dividerButtonsTabbar: UIView = {
        let view             = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    //MARK: -
    //MARK: - Init & View Loading
    init(event: Event) {
        thisEvent = event
        super.init(nibName: nil, bundle: nil)
        setupDefaultValues()
        
        self.view.backgroundColor = LebensfitSettings.Colors.basicBackColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        participateButtonStackView = ParticipateButtonStackView()
        
        fillProvisorischeNutzer()
        setupViews()
        getSnapshotForLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        confBounds()
        setupNavBar()
        setupScrollView()
    }
    
    //MARK: - Setup
    func setupDefaultValues() {
        eventName               = thisEvent.eventName
        eventDescription        = thisEvent.eventDescription
        eventLocation           = thisEvent.eventLocation as? CLLocationCoordinate2D
        eventStartingDate       = thisEvent.eventStartingDate
        eventFinishingDate      = thisEvent.eventFinishingDate
        eventNeedsApplication   = thisEvent.eventNeedsApplication
    }

    func setupNavBar() {
        self.navigationController?.setNavigationBarDefault()
        self.navigationItem.title = "Event"
    }
    
    func setupViews() {
        guard let buttonStackView = participateButtonStackView else { return }
        view.addSubview(buttonStackView)
        buttonStackView.delegate = self
        view.addSubview(dividerButtonsView)
        view.addSubview(dividerButtonsTabbar)

        view.addSubview(scrollView)
    }
    
    func setupScrollView() {
        scrollView.delegateESV = self
        scrollView.setupTheSetup()
        applyScrollViewValues()
        scrollView.setupPeopleTableViewsContentForEvent(event: thisEvent)
    }
    
    func confBounds(){
        let tabbarHeight        = self.tabBarController?.tabBar.frame.height ?? 0

        guard let buttonStackView = participateButtonStackView else { return }
        buttonStackView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: tabbarHeight, paddingRight: 0, width: 0, height: 50)
        dividerButtonsTabbar.anchor(top: buttonStackView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: -0.5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        dividerButtonsView.anchor(top: nil, left: view.leftAnchor, bottom: buttonStackView.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: dividerButtonsView.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    
    //MARK: - Methods
    //copied from: https://dispatchswift.com/render-a-map-as-an-image-using-mapkit-3102a5a3fa5
    func getSnapshotForLocation() {
        let mapSnapshotOptions = MKMapSnapshotter.Options()
        guard let location = eventLocation else { return }
        let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapSnapshotOptions.region = region
        mapSnapshotOptions.scale = UIScreen.main.scale
        mapSnapshotOptions.size = CGSize(width: 400, height: 400)
        mapSnapshotOptions.showsBuildings = true
        mapSnapshotOptions.showsPointsOfInterest = true
        snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
        snapShotter.start { (snapshot:MKMapSnapshotter.Snapshot?, error:Error?) in
            self.scrollView.mapView.image = snapshot?.image
        }
    }
    
    //hardcoded method to set a string for the location //TODO: make smooth
    func getStringFromLocation(location: CLLocationCoordinate2D) -> String{
        if location.latitude == EventLocationStruct.turnhalleEisenwerk.latitude && location.longitude == EventLocationStruct.turnhalleEisenwerk.longitude {
            return "Turnhalle Eisenwerk, Frauenfeld"
        }
        else if location.latitude == EventLocationStruct.zuercherStrasse.latitude && location.longitude == EventLocationStruct.zuercherStrasse.longitude {
            return "Zürcherstrasse, Frauenfeld"
        }
        return "Unbekannt"
    }
    
    func applyScrollViewValues() {
        let locationString = getStringFromLocation(location: thisEvent.eventLocation as! CLLocationCoordinate2D)
        
        scrollView.titleLabel.text = thisEvent.eventName
        scrollView.notesContentLabel.text  = thisEvent.eventDescription
        scrollView.locationLabel.text = locationString
        
        if let start = thisEvent.eventStartingDate, let finish = thisEvent.eventFinishingDate {
            scrollView.timeLabel.text = "Von \(start.getHourAndMinuteAsStringFromDate()) bis \(finish.getHourAndMinuteAsStringFromDate())"
        }
        if let date = thisEvent.eventStartingDate {
            scrollView.dateLabel.text = (date as Date).formatDateEEEEddMMMyyyy()
        }
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SingleEventViewController: participateButtonStackViewDelegate {
    func addUserToList(list: participateLists) {
        guard let currentUser = CDUser.sharedInstance.getCurrentUser() else { return }
        switch list {
        case .sure:
            thisEvent.addToEventSureParticipants(currentUser)
        case .maybe:
            thisEvent.addToEventMaybeParticipants(currentUser)
        case .nope:
            thisEvent.addToEventNopeParticipants(currentUser)
        }
        scrollView.setupPeopleTableViewsContentForEvent(event: thisEvent)
    }
    
    
    //gets called before we add the user to a different list, he cannot be in two lists at the same time
    func removeFromAllParticipantsList() {
        let partList = [thisEvent.eventSureParticipants, thisEvent.eventMaybeParticipants, thisEvent.eventNopeParticipants]
        guard let currentUser = CDUser.sharedInstance.getCurrentUser() else { return }
        for list in partList {
            guard let thisList = list else { return }
            if thisList.contains(currentUser) {
                if thisList == thisEvent.eventSureParticipants {
                    thisEvent.removeFromEventSureParticipants(currentUser)
                } else if thisList == thisEvent.eventMaybeParticipants {
                    thisEvent.removeFromEventMaybeParticipants(currentUser)
                } else if thisList == thisEvent.eventNopeParticipants {
                    thisEvent.removeFromEventNopeParticipants(currentUser)
                }
            }
        }
    }
}

extension SingleEventViewController: eventScrollViewDelegate {
    
    override func viewDidLayoutSubviews() {
        var heightOfAllObjects = scrollView.calculateHeightOfAllObjects()
        heightOfAllObjects -= participateButtonStackView?.frame.height ?? 50
        if heightOfAllObjects != 0 {
            heightOfAllObjects += 12
        }
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: heightOfAllObjects)
        scrollView.heightOfContent.constant = heightOfAllObjects
    }
    
    @objc func openInGoogleMaps() {
        guard let coord = eventLocation else { return }
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coord, addressDictionary:nil))
        mapItem.name = "Target location"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    func gotoProfile(clickedUID: String) {
        let selectedProfile     = ProfileController()
        selectedProfile.userId  = clickedUID
        DispatchQueue.main.async( execute: {
            self.navigationController?.pushViewController(selectedProfile, animated: true)
        })
    }
}
