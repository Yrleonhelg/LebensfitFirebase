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
    
    let padding: CGFloat = 20
    
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
    
    let mapLabel: UILabel = {
        let label           = UILabel()
        label.font          = UIFont.systemFont(ofSize: 16)
        label.text          = "Frauenfeld"
        label.textColor     = LebensfitSettings.Colors.darkRed
        label.textAlignment = .center
        return label
    }()
    
    let notizenLabel: UILabel = {
        let label       = UILabel()
        label.font      = UIFont.systemFont(ofSize: 20)
        label.text      = "Notizen"
        label.textColor = .black
        return label
    }()
    
    let teilnehmerLabel: UILabel = {
        let label       = UILabel()
        label.font      = UIFont.systemFont(ofSize: 20)
        label.text      = "Teilnehmer:"
        label.textColor = .black
        return label
    }()
    let interessentenLabel: UILabel = {
        let label       = UILabel()
        label.font      = UIFont.systemFont(ofSize: 20)
        label.text      = "Interessenten:"
        label.textColor = .black
        return label
    }()
    let absagenLabel: UILabel = {
        let label       = UILabel()
        label.font      = UIFont.systemFont(ofSize: 20)
        label.text      = "Absagen:"
        label.textColor = .black
        return label
    }()
    
    let teilnehmerTV: PeopleTableView = {
        let tvt = PeopleTableView()
        return tvt
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
        button.imageView?.layer.borderWidth = 0
        button.imageView?.layer.borderColor = CalendarSettings.Colors.darkRed.cgColor
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
        button.imageView?.layer.borderWidth = 0
        button.imageView?.layer.borderColor = CalendarSettings.Colors.darkRed.cgColor
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
        button.imageView?.layer.borderWidth = 0
        button.imageView?.layer.borderColor = CalendarSettings.Colors.darkRed.cgColor
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
        applyDefaultValues()
        setupViews()
        getSnapshotForLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        surePeopleTV.parentVC = self
        maybePeopleTV.parentVC = self
        nopePeopleTV.parentVC = self
        
        //todo
        let user = CDUser.sharedInstance.getCurrentUser()
        thisEvent.addToEventSureParticipants(user)
        
        let users = CDUser.sharedInstance.getUsers()
        let nsusers = NSSet(array: users)
        thisEvent.addToEventNopeParticipants(nsusers)
        
        surePeopleTV.loadSureUsers()
        maybePeopleTV.loadMaybeUsers()
        nopePeopleTV.loadNopeUsers()
        
        setupNavBar()
        confBounds()
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
            mapLabel.text       = getStringFromLocation(location: location)
        }
        if let date = eventStartingDate {
            dateLabel.text = formatDate(date: date as Date)
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
        
        dateLabel.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
        timeLabel.anchor(top: dateLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
        
        mapView.anchor(top: timeLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 200)
        
        notizenLabel.anchor(top: mapView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
        descLabel.anchor(top: notizenLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
        
        //print(thisEvent.eventSureParticipants, thisEvent.eventMaybeParticipants, thisEvent.eventNopeParticipants)
    }
    
    override func viewDidLayoutSubviews() {
        var objHeight = titleLabel.frame.height + locationLabel.frame.height + dateLabel.frame.height + timeLabel.frame.height + mapView.frame.height + notizenLabel.frame.height + descLabel.frame.height
        let tableviewsHeight = teilnehmerLabel.frame.height + interessentenLabel.frame.height + absagenLabel.frame.height
        objHeight += tableviewsHeight
        let paddingHeight = 10+0+50+padding+20+20+20 - 15 + 1000
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: objHeight+paddingHeight)
    }
    
    //MARK: - Methods
    @objc func maybeButtonClick() {
        let selected = !maybeButton.isSelected
        deselectAllButtons()
        selectButton(button: maybeButton, selected: selected)
        let currentUser = CDUser.sharedInstance.getCurrentUser()
        
        if selected {
            thisEvent.addToEventMaybeParticipants(currentUser)
        } else {
            thisEvent.removeFromEventMaybeParticipants(currentUser)
        }
    }
    @objc func yesButtonClick() {
        let selected = !participateButton.isSelected
        deselectAllButtons()
        selectButton(button: participateButton, selected: selected)
        let currentUser = CDUser.sharedInstance.getCurrentUser()
        
        if selected {
            thisEvent.addToEventSureParticipants(currentUser)
        } else {
            thisEvent.removeFromEventSureParticipants(currentUser)
        }
    }
    @objc func nopeButtonClick() {
        let selected = !nopeButton.isSelected
        deselectAllButtons()
        selectButton(button: nopeButton, selected: selected)
        let currentUser = CDUser.sharedInstance.getCurrentUser()
        
        if selected {
            thisEvent.addToEventNopeParticipants(currentUser)
        } else {
            thisEvent.removeFromEventNopeParticipants(currentUser)
        }
    }
    
    func deselectAllButtons() {
        let buttons = [nopeButton, maybeButton, participateButton]
        for button in buttons {
            button.backgroundColor      = .white
            button.imageView?.tintColor = LebensfitSettings.Colors.darkRed
            button.isSelected = false
        }
    }
    
    func selectButton(button: UIButton, selected: Bool) {
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

            scrollView.addSubview(teilnehmerLabel)
            scrollView.addSubview(interessentenLabel)
            scrollView.addSubview(absagenLabel)
            
            scrollView.addSubview(surePeopleTV)
            scrollView.addSubview(maybePeopleTV)
            scrollView.addSubview(nopePeopleTV)
            
            let sureTVHeight: CGFloat = CGFloat(surePeopleTV.users.count) * 60
            let maybeTVHeight: CGFloat = CGFloat(maybePeopleTV.users.count) * 60
            let nopeTVHeight: CGFloat = CGFloat(nopePeopleTV.users.count) * 60
            
            teilnehmerLabel.anchor(top: descLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
            surePeopleTV.anchor(top: teilnehmerLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: sureTVHeight)
            
            interessentenLabel.anchor(top: surePeopleTV.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
            maybePeopleTV.anchor(top: interessentenLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: maybeTVHeight)
            
            absagenLabel.anchor(top: interessentenLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
            nopePeopleTV.anchor(top: absagenLabel.bottomAnchor, left: view.leftAnchor, bottom: scrollView.bottomAnchor, right: view.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: nopeTVHeight)
            
            surePeopleTV.peopleTableView.reloadData()
            maybePeopleTV.peopleTableView.reloadData()
            nopePeopleTV.peopleTableView.reloadData()
        }
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_CH")
        formatter.dateFormat = "EEEE, dd. MMM yyyy"
        let result = formatter.string(from: date)
        return result
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
    
    //https://dispatchswift.com/render-a-map-as-an-image-using-mapkit-3102a5a3fa5
    func getSnapshotForLocation() {
        let mapSnapshotOptions = MKMapSnapshotOptions()
        
        // Set the region of the map that is rendered.
        //let location = CLLocationCoordinate2DMake(37.332077, -122.02962) // Apple HQ
        guard let location = eventLocation else { return }
        let region = MKCoordinateRegionMakeWithDistance(location, 2000, 2000)
        mapSnapshotOptions.region = region
        
        // Set the scale of the image. We'll just use the scale of the current device, which is 2x scale on Retina screens.
        mapSnapshotOptions.scale = UIScreen.main.scale
        
        // Set the size of the image output.
        mapSnapshotOptions.size = CGSize(width: 400, height: 400)
        
        // Show buildings and Points of Interest on the snapshot
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //teilnehmerTV.users.removeAll()
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
