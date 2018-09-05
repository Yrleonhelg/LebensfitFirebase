//
//  CalenderController.swift
//  PilatesTest
//
//  Created by Leon Helg on 29.08.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit
import EventKit

enum currentTheme {
    case light
    case dark
}

class CalendarController: UIViewController {
    //MARK: - Properties & Variables
    let calendarView: CalendarView = {
        let cv = CalendarView(theme: currentTheme.light)
        return cv
    }()
    
    var theme = currentTheme.light
    
    //MARK: - GUI Objects
    
    //MARK: - Init & View Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=CalendarSettings.Style.bgColor
        
        setupNavBar()
        setupViews()
        confBounds()
    }
    
    //MARK: - Setup
    func setupNavBar() {
        self.navigationItem.title = "Kalender"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        let rightBarBtn = UIBarButtonItem(title: "Light", style: .plain, target: self, action: #selector(changeTheme))
        self.navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    func setupViews() {
        view.addSubview(calendarView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calendarView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func confBounds(){
        calendarView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 365)
    }
    
    //MARK: - Methods
    @objc func changeTheme(sender: UIBarButtonItem) {
        if theme == .dark {
            sender.title = "Dark"
            theme = .light
            CalendarSettings.Style.themeLight()
        } else {
            sender.title = "Light"
            theme = .dark
            CalendarSettings.Style.themeDark()
        }
        self.view.backgroundColor = CalendarSettings.Style.bgColor
        calendarView.changeTheme()
    }
    
    func addEventToCalendar() {
        let eventStore:EKEventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if let err = error { print("Failed to add Event", err); return }
            if granted {
                let event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = "title"
                event.startDate = Date()
                event.endDate = Date()
                event.notes = "Notes"
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError { print("Failed to save Event:  \(error)"); return}
                print("Event Saved")
            }
            
        }
    }
    
    //MARK: - Do not change Methods
}

