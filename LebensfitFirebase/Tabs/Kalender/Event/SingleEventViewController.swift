//
//  EventViewController.swift
//  LebensfitFirebase
//
//  Created by Leon on 10.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit
import MapKit

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
    
    //MARK: - GUI Objects
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.text = "Titel"
        label.textColor = .black
        return label
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Beschreibung"
        label.textColor = .black
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Von jetzt bis jetzt"
        label.textColor = .black
        return label
    }()
    
    let mapView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.borderWidth = 0
        view.layer.cornerRadius = 5
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let buttonDividerView: UIView = {
        let tdv = UIView()
        tdv.backgroundColor = UIColor.gray
        return tdv
    }()
    
    let participateButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CalendarSettings.Colors.buttonBG
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
        view.backgroundColor = .white
        applyDefaultValues()
        setupNavBar()
        setupViews()
        confBounds()
        getSnapshotForLocation()
    }
    
    //MARK: - Setup
    func setupDefaultValues() {
        eventName = thisEvent.eventName
        eventDescription = thisEvent.eventDescription
        eventLocation = thisEvent.eventLocation
        eventStartingDate = thisEvent.eventStartingDate
        eventFinishingDate = thisEvent.eventFinishingDate
        eventNeedsApplication = thisEvent.eventNeedsApplication
    }
    
    func applyDefaultValues() {
        titleLabel.text = eventName
        descLabel.text = eventDescription
        
        dateLabel.text = "\(eventStartingDate!.getHourAndMinuteAsStringFromDate()) bis \(eventFinishingDate!.getHourAndMinuteAsStringFromDate())"
    }
    
    func setupNavBar() {
        self.navigationItem.title = "Event"
    }
    
    func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(descLabel)
        view.addSubview(dateLabel)
        view.addSubview(mapView)
        view.addSubview(participateButton)
        view.addSubview(buttonDividerView)
    }
    
    func confBounds(){
        let tabbarHeight = self.tabBarController?.tabBar.frame.height ?? 0
        titleLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        descLabel.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        dateLabel.anchor(top: descLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        mapView.anchor(top: dateLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 300)
        participateButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: tabbarHeight, paddingRight: 0, width: 0, height: 50)
        buttonDividerView.anchor(top: nil, left: view.leftAnchor, bottom: participateButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    //MARK: - Methods
    //https://dispatchswift.com/render-a-map-as-an-image-using-mapkit-3102a5a3fa5
    
    func getSnapshotForLocation() {
        let mapSnapshotOptions = MKMapSnapshotOptions()
        
        // Set the region of the map that is rendered.
        //let location = CLLocationCoordinate2DMake(37.332077, -122.02962) // Apple HQ
        let location = eventLocation!
        let region = MKCoordinateRegionMakeWithDistance(location, 1000, 1000)
        mapSnapshotOptions.region = region
        
        // Set the scale of the image. We'll just use the scale of the current device, which is 2x scale on Retina screens.
        mapSnapshotOptions.scale = UIScreen.main.scale
        
        // Set the size of the image output.
        mapSnapshotOptions.size = CGSize(width: 300, height: 300)
        
        // Show buildings and Points of Interest on the snapshot
        mapSnapshotOptions.showsBuildings = true
        mapSnapshotOptions.showsPointsOfInterest = true
        
        snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
        
        snapShotter.start { (snapshot:MKMapSnapshot?, error:Error?) in
            self.mapView.image = snapshot?.image
        }
    }
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
