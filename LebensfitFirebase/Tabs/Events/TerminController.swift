//
//  CalenderController.swift
//  PilatesTest
//
//  Created by Leon Helg on 29.08.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit
import EventKit

class TerminController: UIViewController {
    //MARK: - Properties & Variables
    var eventArray  = [Event]()
    
    //MARK: - GUI Objects
    let segmentedController: UISegmentedControl = {
        let items               = ["Monat", "Woche", "Events"]
        let frame               = UIScreen.main.bounds
        
        let controller                  = UISegmentedControl(items: items)
        controller.selectedSegmentIndex = 0
        controller.frame                = CGRect(x: frame.minX + 10, y: frame.minY + 50, width: frame.width - 20, height: 30)
        controller.layer.cornerRadius   = 5.0
        controller.tintColor            = LebensfitSettings.Colors.basicTintColor
        return controller
    }()
    
    let calendarView: CalendarView = {
        let view = CalendarView()
        return view
    }()
    
    let weekView: WeekView = {
        let view = WeekView()
        return view
    }()
    
    //MARK: - Init & View Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = LebensfitSettings.Calendar.Style.bgColor
        setupNavBar()
        setupViews()
        confBounds()
        fillArray()
        segmentedController.addTarget(self, action: #selector(self.changeView(_:)), for: .valueChanged)
    }
    
    //MARK: - Setup
    func setupNavBar() {
        self.navigationController?.setNavigationBarDefault()
        self.navigationItem.title = "Kalender"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddEvent))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    func setupViews() {
        view.addSubview(segmentedController)
        view.addSubview(calendarView)
        view.addSubview(weekView)
        calendarView.parentVC = self
        calendarView.delegate = self
        weekView.delegate = self
        weekView.parentVC = self
        weekView.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calendarView.calendarCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func confBounds(){
        segmentedController.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        calendarView.anchor(top: segmentedController.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 365)
        weekView.anchor(top: segmentedController.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    //MARK: - Methods
    @objc func changeView(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            changeViewTo(newView: calendarView, oldView: weekView)
        case 1:
            changeViewTo(newView: weekView, oldView: calendarView)
        default:
            changeViewTo(newView: calendarView, oldView: weekView)
        }
    }
    
    func changeViewTo(newView: UIView, oldView: UIView) {
        newView.isHidden = false
        newView.alpha = 0
        UIView.animate(withDuration:0.4, animations: {
            oldView.alpha = 0
            newView.alpha = 1
        }) { (result: Bool) in
            oldView.isHidden = true
        }
    }

    
    @objc func handleAddEvent() {
        let createEventController = CreateEventController()
        let createEventNavigationController = LebensfitNavigation(rootViewController: createEventController)
        present(createEventNavigationController, animated: true, completion: nil)
    }
}

extension TerminController: cellClickedDelegate {
    //Opens the weekview and expands the selcted day
    func gotoDay(date: Date) {
        changeViewTo(newView: weekView, oldView: calendarView)
        segmentedController.selectedSegmentIndex = 1
        
        let weekOfDate = Calendar.current.component(.weekOfYear, from: date)
        let yearOfDate = Calendar.current.component(.year, from: date)
        
        weekView.presentDate = date
        weekView.setnewWeekValues(week: weekOfDate, year: yearOfDate)
        weekView.setupValues()
        weekView.setupArray()
        
        //Make Header automaticly expand (with deadline that it appears after view is there
        if weekView.twoDimensionalEventArray.count > date.weekday.formatedWeekDay {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.weekView.expandHeader(section: date.weekday.formatedWeekDay)
            }
        }
    }
}

extension TerminController: weekViewToTerminController {
    func getEventArray() -> [Event] {
        return eventArray
    }
    
    //Goes directly to an event
    func gotoEvent(eventID: Int32) {
        let event = eventArray[Int(eventID)]
        let eventVC = SingleEventViewController(event: event)
        DispatchQueue.main.async( execute: {
            self.navigationController?.pushViewController(eventVC, animated: true)
        })
    }
    
}
