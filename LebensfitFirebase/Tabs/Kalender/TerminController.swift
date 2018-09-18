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

class TerminController: UIViewController {
    //MARK: - Properties & Variables
    var theme       = currentTheme.light
    
    var eventArray  = [Event]()
    
    //MARK: - GUI Objects
    let segmentedController: UISegmentedControl = {
        let items               = ["Monat", "Woche"]
        let frame               = UIScreen.main.bounds
        
        let sc                  = UISegmentedControl(items: items)
        sc.selectedSegmentIndex = 0
        sc.frame                = CGRect(x: frame.minX + 10, y: frame.minY + 50, width: frame.width - 20, height: 30)
        sc.layer.cornerRadius   = 5.0
        return sc
    }()
    
    let calendarView: CalendarView = {
        let cv = CalendarView(theme: currentTheme.light)
        return cv
    }()
    
    let weekView = WeekView()
    
    //MARK: - Init & View Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = CalendarSettings.Style.bgColor
        setupNavBar()
        setupViews()
        confBounds()
        fillArray()
    }
    
    //MARK: - Setup
    func setupNavBar() {
        self.navigationController?.setNavigationBarDefault()
        self.navigationItem.title = "Kalender"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.titleView = segmentedController
        segmentedController.addTarget(self, action: #selector(changeView(sender:)), for: .valueChanged)
    }
    
    func setupViews() {
        view.addSubview(calendarView)
        view.addSubview(weekView)
        calendarView.parentVC = self
        weekView.parentVC = self
        weekView.removeFromSuperview()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calendarView.calendarCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func confBounds(){
        calendarView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 365)
    }
    
    //MARK: - Methods
    @objc func changeView(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            gotoWeekView()
        default:
            gotoMonthView()
        }
    }
    
    func gotoWeekView() {
        calendarView.removeFromSuperview()
        view.addSubview(weekView)
        weekView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        weekView.setupTheSetup()
    }
    
    func gotoMonthView() {
        weekView.removeFromSuperview()
        view.addSubview(calendarView)
        calendarView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 365)
    }
    
    @objc func changeTheme(sender: UIBarButtonItem) {
        if theme == .dark {
            sender.title    = "Dark"
            theme           = .light
            CalendarSettings.Style.themeLight()
        } else {
            sender.title    = "Light"
            theme           = .dark
            CalendarSettings.Style.themeDark()
        }
        self.view.backgroundColor = CalendarSettings.Style.bgColor
        calendarView.changeTheme()
    }
    
    //Opens the weekview and expands the selcted day
    func gotoDay(date: Date) {
        gotoWeekView()
        segmentedController.selectedSegmentIndex = 1
        print(date)
        let weekOfDate = Calendar.current.component(.weekOfYear, from: date)
        let yearOfDate = Calendar.current.component(.year, from: date)
    
        weekView.presentDate = date
        weekView.setnewWeekValues(week: weekOfDate, year: yearOfDate)
        weekView.setupValues()
        weekView.setupArray()
        print("start")
        
        //Make Header automaticly expand (with deadline that it appears after view is there
        if weekView.twoDimensionalEventArray.count > date.weekday.formatedWeekDay {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.weekView.expandHeader(section: date.weekday.formatedWeekDay)
            }
        }
    }
    
    func gotoEvent(eventID: Int) {
        let event = eventArray[eventID]
        let eventVC = SingleEventViewController(event: event)
        DispatchQueue.main.async( execute: {
            self.navigationController?.pushViewController(eventVC, animated: true)
        })
    }
}

