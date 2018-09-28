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
    var buttons: [UIButton]!
    
    //MARK: - GUI Objects
    var scrollView: EventScrollView?
    
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
    
    //separates two buttons
    let separatorNopeMaybe: UIView = {
        let view             = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    let separatorMaybeSure: UIView = {
        let view             = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    let participateButton: UIButton = {
        let button              = UIButton()
        button.backgroundColor  = LebensfitSettings.Colors.buttonBG
        button.tintColor        = LebensfitSettings.Colors.basicTintColor
        let buttonImage = UIImage(named: "checkmark2")?.withRenderingMode(.alwaysTemplate)
        button.setImage(buttonImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    let maybeButton: UIButton = {
        let button              = UIButton()
        button.backgroundColor  = LebensfitSettings.Colors.buttonBG
        button.tintColor        = LebensfitSettings.Colors.basicTintColor
        let buttonImage = UIImage(named: "questionmark2")?.withRenderingMode(.alwaysTemplate)
        button.setImage(buttonImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    let nopeButton: UIButton = {
        let button              = UIButton()
        button.isEnabled            = true
        button.backgroundColor  = LebensfitSettings.Colors.buttonBG
        button.tintColor        = LebensfitSettings.Colors.basicTintColor
        let buttonImage = UIImage(named: "delete-sign")?.withRenderingMode(.alwaysTemplate)
        button.setImage(buttonImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    //MARK: - Init & View Loading
    init(event: Event) {
        thisEvent = event
        super.init(nibName: nil, bundle: nil)
        setupDefaultValues()
        self.view.backgroundColor = LebensfitSettings.Colors.basicBackColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons = [nopeButton, maybeButton, participateButton]
        fillProvisorischeNutzer()
        setupScrollView()
        setupViews()
        
        getSnapshotForLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        confBounds()
        setupNavBar()
        scrollView?.viewDidAppear()
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
    
    func setupScrollView() {
        self.scrollView = EventScrollView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), event: thisEvent)
        guard let scrollView = scrollView else { return }
        scrollView.delegateSVToSingleEvent = self
        scrollView.setupTheSetup()
    }
    
    func setupViews() {
        view.addSubview(maybeButton)
        view.addSubview(nopeButton)
        view.addSubview(participateButton)
        view.addSubview(separatorMaybeSure)
        view.addSubview(separatorNopeMaybe)
        view.addSubview(dividerButtonsView)
        view.addSubview(dividerButtonsTabbar)
        participateButton.addTarget(self, action: #selector (buttonClick(sender:)), for: .touchUpInside)
        maybeButton.addTarget(self, action: #selector (buttonClick(sender:)), for: .touchUpInside)
        nopeButton.addTarget(self, action: #selector (buttonClick(sender:)), for: .touchUpInside)
        
        guard let scrollView = scrollView else { return }
        view.addSubview(scrollView)
    }
    
    func confBounds(){
        let tabbarHeight        = self.tabBarController?.tabBar.frame.height ?? 0
        print(tabbarHeight)
        let buttonDividerWidth  = view.frame.width / 3
        print(UIApplication.shared.statusBarFrame.height)
        
        //TODO: Put buttons into stackview..
        //buttons first because they not in the scrollview and the scrollview uses it's anchor
        nopeButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: tabbarHeight, paddingRight: 0, width: buttonDividerWidth, height: 50)
        nopeButton.imageView!.layer.cornerRadius = maybeButton.imageView!.layer.frame.height / 2
        separatorNopeMaybe.anchor(top: participateButton.topAnchor, left: nopeButton.rightAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: tabbarHeight, paddingRight: 0, width: 0.5, height: 0)
        
        maybeButton.anchor(top: nil, left: separatorNopeMaybe.rightAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: tabbarHeight, paddingRight: 0, width: buttonDividerWidth, height: 50)
        maybeButton.imageView!.layer.cornerRadius = maybeButton.imageView!.layer.frame.height / 2
        separatorMaybeSure.anchor(top: participateButton.topAnchor, left: maybeButton.rightAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: tabbarHeight, paddingRight: 0, width: 0.5, height: 0)
        
        participateButton.anchor(top: nil, left: separatorMaybeSure.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: tabbarHeight, paddingRight: 0, width: 0, height: 50)
        participateButton.imageView!.anchor(top: participateButton.topAnchor, left: nil, bottom: participateButton.bottomAnchor, right: nil, paddingTop: 7, paddingLeft: 0, paddingBottom: 7, paddingRight: 0, width: 0, height: 0)
        participateButton.imageView!.widthAnchor.constraint(equalTo: participateButton.imageView!.heightAnchor, multiplier: 1).isActive = true
        
        dividerButtonsTabbar.anchor(top: participateButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: -0.5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        dividerButtonsView.anchor(top: nil, left: view.leftAnchor, bottom: participateButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        guard let scrollView = scrollView else { return }
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: dividerButtonsView.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    
    //MARK: - Methods
    @objc func buttonClick(sender: UIButton) {
        let selected = !sender.isSelected
        deselectAllButtons()
        removeFromAllParticipantsList()
        selectButton(button: sender, selected: selected)
        if selected {
            addUserToList(sender: sender)
        }
        scrollView?.reloadAllTableViews()
    }
    
    func addUserToList(sender: UIButton) {
        guard let currentUser = CDUser.sharedInstance.getCurrentUser() else { return }
        if sender == maybeButton {
            thisEvent.addToEventMaybeParticipants(currentUser)
        } else if sender == participateButton {
            thisEvent.addToEventSureParticipants(currentUser)
        } else {
            thisEvent.addToEventNopeParticipants(currentUser)
        }
    }
    
    func deselectAllButtons() {
        for button in buttons {
            button.backgroundColor      = LebensfitSettings.Colors.buttonBG
            button.imageView?.tintColor = LebensfitSettings.Colors.basicTintColor
            button.isSelected           = false
        }
    }
    
    func selectButton(button: UIButton, selected: Bool) {
        if selected {
            button.backgroundColor      = LebensfitSettings.Colors.basicTintColor
            button.imageView?.tintColor = .white
            button.isSelected           = true
        } else {
            button.backgroundColor      = .white
            button.imageView?.tintColor = LebensfitSettings.Colors.basicTintColor
            button.isSelected           = false
        }
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
            self.scrollView?.mapView.image = snapshot?.image
        }
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SingleEventViewController: scrollViewToSingleEvent {
    
    override func viewDidLayoutSubviews() {
        guard let scrollView = scrollView else { return }
        var heightOfAllObjects = scrollView.calculateHeightOfAllObjects()
        heightOfAllObjects -= participateButton.frame.height
        if heightOfAllObjects != 0 {
            heightOfAllObjects += 12
        }
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: heightOfAllObjects)
        scrollView.heightOfContent.constant = heightOfAllObjects
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
    
    @objc func openInGoogleMaps() {
        guard let coord = eventLocation else { return }
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coord, addressDictionary:nil))
        mapItem.name = "Target location"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    func getSingleEventVC() -> SingleEventViewController {
        return self
    }
}

extension SingleEventViewController: tableViewToSingleEvent {
    func gotoProfile(clickedUID: String) {
        let selectedProfile     = ProfileController()
        selectedProfile.userId  = clickedUID
        DispatchQueue.main.async( execute: {
            self.navigationController?.pushViewController(selectedProfile, animated: true)
        })
    }
}
