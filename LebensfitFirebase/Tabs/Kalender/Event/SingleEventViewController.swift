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
    var eventStartingDate: Date?
    var eventFinishingDate: Date?
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
        label.text      = "Teilnehmer"
        label.textColor = .black
        return label
    }()
    
    let teilnehmerTV: TeilnehmerTableView = {
        let tvt             = TeilnehmerTableView()
        tvt.backgroundColor = .brown
        return tvt
    }()
    
    let buttonDividerView: UIView = {
        let tdv             = UIView()
        tdv.backgroundColor = UIColor.gray
        return tdv
    }()
    
    let participateButton: UIButton = {
        let button              = UIButton()
        button.backgroundColor  = CalendarSettings.Colors.buttonBG
        button.setTitle("Teilnehmen", for: .normal)
        button.setTitleColor(CalendarSettings.Colors.darkRed, for: .normal)
        return button
    }()
    
    
    
    //MARK: - Init & View Loading
    init(event: Event) {
        thisEvent = event
        super.init(nibName: nil, bundle: nil)
        setupDefaultValues()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyDefaultValues()
        setupNavBar()
        setupViews()
        confBounds()
        getSnapshotForLocation()
    }
    
    
    //MARK: - Setup
    func setupDefaultValues() {
        eventName               = thisEvent.eventName
        eventDescription        = thisEvent.eventDescription
        eventLocation           = thisEvent.eventLocation
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
            dateLabel.text = formatDate(date: date)
        }
    }
    
    func setupNavBar() {
        self.navigationController?.setNavigationBarDefault()
        self.navigationItem.title = "Event"
    }
    
    func setupViews() {
        view.addSubview(scrollView)
        view.addSubview(participateButton)
        participateButton.addTarget(self, action: #selector (buttonClick), for: .touchUpInside)
        view.addSubview(buttonDividerView)
        
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
        scrollView.addSubview(teilnehmerLabel)
        teilnehmerTV.parentVC = self
        teilnehmerTV.fetchUsers()
    }
    
    func confBounds(){
        let tabbarHeight = self.tabBarController?.tabBar.frame.height ?? 0
        
        participateButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: tabbarHeight, paddingRight: 0, width: 0, height: 50)
        buttonDividerView.anchor(top: nil, left: view.leftAnchor, bottom: participateButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: buttonDividerView.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        //Scrollview related Objects
        titleLabel.anchor(top: scrollView.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
        locationLabel.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: padding, paddingBottom: 0, paddingRight: 0, width: 200, height: 0)
        
        dateLabel.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
        timeLabel.anchor(top: dateLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
        
        mapView.anchor(top: timeLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 200)
        
        notizenLabel.anchor(top: mapView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
        descLabel.anchor(top: notizenLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
        
        teilnehmerLabel.anchor(top: descLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
    }
    
    override func viewDidLayoutSubviews() {
        let objHeight = titleLabel.frame.height + locationLabel.frame.height + dateLabel.frame.height + timeLabel.frame.height + mapView.frame.height + notizenLabel.frame.height + descLabel.frame.height + teilnehmerLabel.frame.height + teilnehmerTV.frame.height
        let paddingHeight = 10+0+50+padding+20+5 - 15
        print(objHeight, paddingHeight)
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: objHeight+paddingHeight)
    }
    
    //MARK: - Methods
    @objc func buttonClick() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        thisEvent.eventParticipants?.append(currentUserID)
    }
    
    func teilnehmerLoaded() {
        let tableviewHeight: CGFloat = CGFloat(teilnehmerTV.users.count) * 60
        scrollView.addSubview(teilnehmerTV)
        teilnehmerTV.anchor(top: teilnehmerLabel.bottomAnchor, left: view.leftAnchor, bottom: scrollView.bottomAnchor, right: view.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: tableviewHeight)
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
        print("tapped")
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
        let location = eventLocation!
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
        self.navigationController?.pushViewController(selectedProfile, animated: true)
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
