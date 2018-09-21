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
import CoreData

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
    var tableViewControllers: [PeopleTableView]!
    var tableViews: [UITableView]!
    
    let padding: CGFloat = 20
    var heightOfAllPaddings: CGFloat = 0
    var heightCons = [NSLayoutConstraint]()
    
    
    //MARK: - GUI Objects
    let scrollView: UIScrollView = {
        let view = UIScrollView()
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
        label.textColor     = CalendarSettings.Colors.darkRed
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let descLabel: UILabel = {
        let label           = UILabel()
        label.font          = UIFont.systemFont(ofSize: 16)
        label.text          = "Beschreibung"
        label.textColor     = .gray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
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
        view.layer.borderWidth  = 0
        view.layer.cornerRadius = 10
        view.contentMode        = .scaleAspectFill
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let notizenLabel: UILabel = {
        let label       = UILabel()
        label.font      = UIFont.systemFont(ofSize: 20)
        label.text      = "Notizen"
        label.textColor = .black
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
    
    //divides the buttons from the rest of the view
    let buttonViewDividerView: UIView = {
        let tdv             = UIView()
        tdv.backgroundColor = UIColor.gray
        return tdv
    }()
    
    let buttonViewDividerViewTwo: UIView = {
        let tdv             = UIView()
        tdv.backgroundColor = UIColor.gray
        return tdv
    }()
    
    //divides the two buttons
    let buttonSeparatorView: UIView = {
        let tdv             = UIView()
        tdv.backgroundColor = UIColor.gray
        return tdv
    }()
    
    let buttonSeparatorViewTwo: UIView = {
        let tdv             = UIView()
        tdv.backgroundColor = UIColor.gray
        return tdv
    }()
    
    let participateButton: UIButton = {
        let button              = UIButton()
        button.backgroundColor  = CalendarSettings.Colors.buttonBG
        button.tintColor        = CalendarSettings.Colors.darkRed
        
        let buttonImage: UIImage = {
            let image           = UIImage(named: "checkmark2")?.withRenderingMode(.alwaysTemplate)
            return image!
        }()
        button.setImage(buttonImage, for: .normal)
        button.imageView?.contentMode       = .scaleAspectFit
        return button
    }()
    
    let maybeButton: UIButton = {
        let button              = UIButton()
        button.backgroundColor  = CalendarSettings.Colors.buttonBG
        button.tintColor        = CalendarSettings.Colors.darkRed
        let buttonImage: UIImage = {
            let image = UIImage(named: "questionmark2")?.withRenderingMode(.alwaysTemplate)
            return image!
        }()
        
        button.setImage(buttonImage, for: .normal)
        button.imageView?.contentMode       = .scaleAspectFit
        return button
    }()
    
    let nopeButton: UIButton = {
        let button              = UIButton()
        button.isEnabled = true
        button.backgroundColor  = CalendarSettings.Colors.buttonBG
        button.tintColor        = CalendarSettings.Colors.darkRed
        let buttonImage: UIImage = {
            let image = UIImage(named: "delete-sign")?.withRenderingMode(.alwaysTemplate)
            return image!
        }()
        
        button.setImage(buttonImage, for: .normal)
        button.imageView?.contentMode       = .scaleAspectFit
        return button
    }()
    
    
    
    //MARK: - Init & View Loading
    init(event: Event) {
        thisEvent = event
        super.init(nibName: nil, bundle: nil)
        setupDefaultValues()
        self.view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewControllers = [surePeopleTV, maybePeopleTV, nopePeopleTV]
        tableViews = [surePeopleTV.peopleTableView, maybePeopleTV.peopleTableView, nopePeopleTV.peopleTableView]
        provisorischeNutzer()
        applyDefaultValues()
        setupViews()
        getSnapshotForLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        confBounds()
        for controller in tableViewControllers {
            controller.loadUsers()
        }
        setupNavBar()
        
    }
    
    func provisorischeNutzer() {
        //todo
        let user = CDUser.sharedInstance.getCurrentUser()
        thisEvent.addToEventSureParticipants(user)
        
        let users = CDUser.sharedInstance.getUsers()
        let nsusers = NSSet(array: users)
        thisEvent.addToEventNopeParticipants(nsusers)
        //todoend
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
    
    func applyDefaultValues() {
        titleLabel.text = eventName
        descLabel.text  = eventDescription
        if let start = eventStartingDate, let finish = eventFinishingDate {
            timeLabel.text = "Von \(start.getHourAndMinuteAsStringFromDate()) bis \(finish.getHourAndMinuteAsStringFromDate())"
        }
        
        if let location = eventLocation {
            locationLabel.text  = getStringFromLocation(location: location)
        }
        if let date = eventStartingDate {
            dateLabel.text = (date as Date).formatDateEEEEddMMMyyyy()
        }
    }
    
    func setupNavBar() {
        self.navigationController?.setNavigationBarDefault()
        self.navigationItem.title = "Event"
    }
    
    func setupViews() {
        view.addSubview(scrollView)
        view.addSubview(maybeButton)
        view.addSubview(nopeButton)
        view.addSubview(participateButton)
        view.addSubview(buttonSeparatorView)
        view.addSubview(buttonSeparatorViewTwo)
        view.addSubview(buttonViewDividerView)
        view.addSubview(buttonViewDividerViewTwo)
        participateButton.addTarget(self, action: #selector (yesButtonClick), for: .touchUpInside)
        maybeButton.addTarget(self, action: #selector (maybeButtonClick), for: .touchUpInside)
        nopeButton.addTarget(self, action: #selector (nopeButtonClick), for: .touchUpInside)
        
        //Scrollview related Objects
        let locationTap = UITapGestureRecognizer(target: self, action: #selector(self.openInGoogleMaps))
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(locationLabel)
        locationLabel.addGestureRecognizer(locationTap)
        scrollView.addSubview(timeLabel)
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(mapView)
        mapView.addGestureRecognizer(locationTap)
        scrollView.addSubview(notizenLabel)
        scrollView.addSubview(descLabel)
        
        for controller in tableViewControllers {
            scrollView.addSubview(controller)
            controller.parentVC = self
            let heightCon = controller.heightAnchor.constraint(equalToConstant: 0)
            heightCon.isActive = true
            heightCons.append(heightCon)
        }
    }
    
    
    func confBounds(){
        let tabbarHeight        = self.tabBarController?.tabBar.frame.height ?? 0
        let buttonDividerWidth  = view.frame.width / 3
        
        //buttons first because they not in the scrollview
        nopeButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: tabbarHeight, paddingRight: 0, width: buttonDividerWidth, height: 50)
        nopeButton.imageView!.layer.cornerRadius = maybeButton.imageView!.layer.frame.height / 2
        buttonSeparatorViewTwo.anchor(top: participateButton.topAnchor, left: nopeButton.rightAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: tabbarHeight, paddingRight: 0, width: 0.5, height: 0)
        
        maybeButton.anchor(top: nil, left: buttonSeparatorViewTwo.rightAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: tabbarHeight, paddingRight: 0, width: buttonDividerWidth, height: 50)
        maybeButton.imageView!.layer.cornerRadius = maybeButton.imageView!.layer.frame.height / 2
        buttonSeparatorView.anchor(top: participateButton.topAnchor, left: maybeButton.rightAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: tabbarHeight, paddingRight: 0, width: 0.5, height: 0)
        
        participateButton.anchor(top: nil, left: buttonSeparatorView.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: tabbarHeight, paddingRight: 0, width: 0, height: 50)
        participateButton.imageView!.anchor(top: participateButton.topAnchor, left: nil, bottom: participateButton.bottomAnchor, right: nil, paddingTop: 7, paddingLeft: 0, paddingBottom: 7, paddingRight: 0, width: 0, height: 0)
        participateButton.imageView!.widthAnchor.constraint(equalTo: participateButton.imageView!.heightAnchor, multiplier: 1).isActive = true
        
        buttonViewDividerViewTwo.anchor(top: participateButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: -0.5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        buttonViewDividerView.anchor(top: nil, left: view.leftAnchor, bottom: participateButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: buttonViewDividerView.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        //Scrollview related Objects
        titleLabel.anchor(top: scrollView.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
        locationLabel.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: padding, paddingBottom: 0, paddingRight: 0, width: 200, height: 0)
            heightOfAllPaddings += 10
        
        dateLabel.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
        timeLabel.anchor(top: dateLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
            heightOfAllPaddings += 50
        
        mapView.anchor(top: timeLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 200)
            heightOfAllPaddings += padding
        
        notizenLabel.anchor(top: mapView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
        descLabel.anchor(top: notizenLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
            heightOfAllPaddings += 20 + 5
        
        surePeopleTV.anchor(top: descLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        maybePeopleTV.anchor(top: surePeopleTV.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        nopePeopleTV.anchor(top: maybePeopleTV.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    override func viewDidLayoutSubviews() {
        let heightOfAllObjects = calculateHeightOfAllObjects()
        scrollView.contentSize = CGSize(width: view.frame.width, height: heightOfAllObjects+heightOfAllPaddings)
    }
    
    //MARK: - Methods
    func calculateHeightOfAllObjects() -> CGFloat {
        var heightOfAllObjects: CGFloat = 0
        heightOfAllObjects += titleLabel.frame.height + locationLabel.frame.height
        heightOfAllObjects += dateLabel.frame.height + timeLabel.frame.height
        heightOfAllObjects += mapView.frame.height
        heightOfAllObjects += notizenLabel.frame.height + descLabel.frame.height
        
        for controller in tableViewControllers {
            var height = CGFloat(controller.users.count) * controller.height
            if controller.users.count > 0 {
                height += controller.padding
            }
            heightOfAllObjects += height
        }

        heightOfAllObjects -= participateButton.frame.height
        heightOfAllObjects += 14
        print("=",heightOfAllObjects)
        return heightOfAllObjects
    }
    
    @objc func maybeButtonClick() {
        let selected = !maybeButton.isSelected
        selectButton(button: maybeButton, selected: selected)
        let currentUser = CDUser.sharedInstance.getCurrentUser()
        
        if selected {
            thisEvent.addToEventMaybeParticipants(currentUser)
        }
        reloadAllTableViews()
    }
    @objc func yesButtonClick() {
        let selected = !participateButton.isSelected
        selectButton(button: participateButton, selected: selected)
        let currentUser = CDUser.sharedInstance.getCurrentUser()
        
        if selected {
            thisEvent.addToEventSureParticipants(currentUser)
        }
        reloadAllTableViews()
    }
    @objc func nopeButtonClick() {
        let selected = !nopeButton.isSelected
        selectButton(button: nopeButton, selected: selected)
        let currentUser = CDUser.sharedInstance.getCurrentUser()
        
        if selected {
            thisEvent.addToEventNopeParticipants(currentUser)
        }
        reloadAllTableViews()
    }
    
    func deselectAllButtons() {
        let buttons = [nopeButton, maybeButton, participateButton]
        for button in buttons {
            button.backgroundColor      = .white
            button.imageView?.tintColor = LebensfitSettings.Colors.darkRed
            button.isSelected = false
        }
    }
    
    //gets called before we add the user to a different list, he cannot be in two lists at the same time
    func removeFromAllParticipantsList() {
        let partList = [thisEvent.eventSureParticipants, thisEvent.eventMaybeParticipants, thisEvent.eventNopeParticipants]
        let currentUser = CDUser.sharedInstance.getCurrentUser()
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
    
    func selectButton(button: UIButton, selected: Bool) {
        deselectAllButtons()
        removeFromAllParticipantsList()
        if selected {
            button.backgroundColor      = LebensfitSettings.Colors.darkRed
            button.imageView?.tintColor = .white
            button.isSelected = true
        } else {
            button.backgroundColor      = .white
            button.imageView?.tintColor = LebensfitSettings.Colors.darkRed
            button.isSelected = false
        }
    }
    
    func teilnehmerLoaded() {
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
                view.layoutIfNeeded()
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
    
    //https://dispatchswift.com/render-a-map-as-an-image-using-mapkit-3102a5a3fa5
    func getSnapshotForLocation() {
        let mapSnapshotOptions = MKMapSnapshotOptions()
        guard let location = eventLocation else { return }
        let region = MKCoordinateRegionMakeWithDistance(location, 2000, 2000)
        mapSnapshotOptions.region = region
        mapSnapshotOptions.scale = UIScreen.main.scale
        mapSnapshotOptions.size = CGSize(width: 400, height: 400)
        mapSnapshotOptions.showsBuildings = true
        mapSnapshotOptions.showsPointsOfInterest = true
        snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
        snapShotter.start { (snapshot:MKMapSnapshot?, error:Error?) in
            self.mapView.image = snapshot?.image
        }
    }
    
    //MARK: - Navigation
    func gotoProfile(clickedUID: String) {
        let selectedProfile     = ProfileController()
        selectedProfile.userId  = clickedUID
        DispatchQueue.main.async( execute: {
            self.navigationController?.pushViewController(selectedProfile, animated: true)
        })
    }
    
    @objc func openInGoogleMaps() {
        guard let coord = eventLocation else { return }
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coord, addressDictionary:nil))
        mapItem.name = "Target location"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
