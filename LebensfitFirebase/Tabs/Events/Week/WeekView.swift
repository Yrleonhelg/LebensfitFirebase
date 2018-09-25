//
//  WeekView.swift
//  LebensfitFirebase
//
//  Created by Leon on 06.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

struct expandableEvent {
    var isExpanded: Bool
    let events: [Event]
}

protocol eventClickedDelegate: Any {
    func gotoEvent(eventID: Int32)
}

class WeekView: UIView {
    
    //MARK: - Properties & Variables
    let monthsShortArr              = ["Jan", "Feb", "März", "Apr", "Mai", "Jun", "Jul", "Aug", "Sep", "Okt", "Nov", "Dez"]
    let numOfDaysInMonth            = [31,28,31,30,31,30,31,31,30,31,30,31]
    let WeekDays                    = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"]
    var currentMonth: Int           = 0
    var currentYear: Int            = 0
    var currentWeek: Int            = 0
    var currentWeekDayIndex: Int    = 0
    var currentDayDate: Int         = 0
    var todaysDate                  = Date()
    var presentDate                 = Date()
    var presentYear                 = 0
    var mondayOfPresentWeek         = Date()
    var lastExpandedHeader: WeekDayHeader?
    
    var twoDimensionalEventArray    = [expandableEvent]()
    var parentVC: TerminController?
    var delegate: eventClickedDelegate?
    
    //MARK: - GUI Objects
    let calendarTableView: UITableView = {
        let ctv     = UITableView()
        return ctv
    }()
    
    let weekOverView: WeekOverView = {
        let wv = WeekOverView()
        return wv
    }()
    
    //MARK: - Init & View Loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor    = LebensfitSettings.Colors.basicBackColor
        presentDate             = Date()
        setupTheSetup()
    }
    
    func setupTheSetup() {
        setupTableView()
        setupViews()
        confBounds()
        setupValues()
        setupArray()
    }
    
    //MARK: - Setup
    func setupTableView() {
        calendarTableView.delegate          = self
        calendarTableView.dataSource        = self
        calendarTableView.tintColor         = LebensfitSettings.Colors.basicBackColor
        calendarTableView.separatorStyle    = .none
        calendarTableView.register(EventTableCell.self, forCellReuseIdentifier: EventTableCell.reuseIdentifier)
        calendarTableView.register(WeekDayHeader.self, forHeaderFooterViewReuseIdentifier: WeekDayHeader.reuseIdentifier)
    }
    
    func setupValues() {
        currentYear         = Calendar.current.component(.year, from: presentDate)
        currentMonth        = Calendar.current.component(.month, from: presentDate)
        currentWeek         = Calendar.current.component(.weekOfYear, from: presentDate)
        currentDayDate      = Calendar.current.component(.day, from: presentDate)
        currentWeekDayIndex = Calendar.current.component(.weekday, from: presentDate).formatedWeekDay
        mondayOfPresentWeek = presentDate.addDaysToToday(amount: -currentWeekDayIndex)
        todaysDate          = Date()
    }
    
    func setupViews() {
        addSubview(weekOverView)
        weekOverView.delegate = self
        addSubview(calendarTableView)
    }
    
    func confBounds() {
        weekOverView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 35)
        calendarTableView.anchor(top: weekOverView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    

    //MARK: - Methods
    //MARK: Reload
    func setnewWeekValues(week: Int, year: Int) {
        currentWeek = week
        currentYear = year
        
        //If method is called from parent it secures that the week on weekoverview is correct
        weekOverView.currentWeek = week
        weekOverView.currentYear = year
        reloadData()
    }
    
    @objc func reloadData() {
        DispatchQueue.main.async( execute: {
            self.calendarTableView.reloadData()
            self.weekOverView.setValues(week: self.currentWeek, Year: self.currentYear)
        })
    }
    
    
    //MARK: Header
    func isExpandedOrNot(view: WeekDayHeader) {
        if view.tag < twoDimensionalEventArray.count {
            let isExpanded = twoDimensionalEventArray[view.tag].isExpanded
            setValuesOfHeader(isExpanded: isExpanded, section: view.tag, headerView: view)
        } else {
            view.chevronLabel.textColor = LebensfitSettings.Colors.disabled
        }
    }
    
    func unexpandAllHeaders() {
        let numb = numberOfSections(in: calendarTableView)
        var i = 0
        while i < numb && i < twoDimensionalEventArray.count {
            setValuesOfHeader(isExpanded: false, section: i, headerView: nil)
            i += 1
        }
    }
    
    func expandHeader(section: Int) {
        twoDimensionalEventArray[section].isExpanded = true
        setValuesOfHeader(isExpanded: true, section: section, headerView: nil)
    }
    
    //Changes the appearance of the header, based on the property if it should show it child views
    func setValuesOfHeader(isExpanded: Bool, section: Int, headerView: WeekDayHeader?) {
        let indexPaths = makeIndexPathArray(section: section)
        let numberOfRows = calendarTableView.numberOfRows(inSection: section)
        
        //If a header value is passed it takes it and else it creares it with the section
        let newHeaderView: WeekDayHeader
        if let header = headerView {
            newHeaderView = header
        } else {
            newHeaderView = calendarTableView.headerView(forSection: section) as! WeekDayHeader
        }
        
        if isExpanded {
            if numberOfRows == 0 {
                calendarTableView.insertRows(at: indexPaths, with: .fade)
            }
            newHeaderView.chevronLabel.text         = "⌄"
            newHeaderView.dayLabel.textColor        = LebensfitSettings.Colors.basicTintColor
            newHeaderView.chevronLabel.textColor    = LebensfitSettings.Colors.basicTintColor
            newHeaderView.isSelected                = true
            lastExpandedHeader                      = newHeaderView
            
        } else {
            if numberOfRows != 0 {
                calendarTableView.deleteRows(at: indexPaths, with: .fade)
            }
            newHeaderView.chevronLabel.text         = "›"
            newHeaderView.dayLabel.textColor        = .black
            newHeaderView.chevronLabel.textColor    = .black
            newHeaderView.isSelected                = false
        }
    }
    
    //MARK: - Helper
    //creates the index paths out of our array. passed is the section
    func makeIndexPathArray(section: Int) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for row in twoDimensionalEventArray[section].events.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        return indexPaths
    }
    
    //Loops trough the parents array of events and puts the ones that are in the displayed week in an array (sorted by day).
    func setupArray() {
        twoDimensionalEventArray.removeAll()
        guard let parent        = parentVC else { return }
        let numberOfWeekdays    = 7
        let lengthOfArray       = parent.eventArray.count
        
        for x in 0..<numberOfWeekdays {
            let currentDay              = mondayOfPresentWeek.addDaysToToday(amount: x)
            var eventsToAddForThatDay   = [Event]()
            
            for i in 0..<lengthOfArray {
                let event                   = parent.eventArray[i]
                guard let eventStartTime    = event.eventStartingDate else { return }
                let isSameDay               = Calendar.current.isDate(currentDay, inSameDayAs: eventStartTime as Date)
                if isSameDay {
                    eventsToAddForThatDay.append(event)
                }
            }
            twoDimensionalEventArray.append(expandableEvent(isExpanded: false, events: eventsToAddForThatDay))
        }
    }
    
    func manageLastHeader(selectedView: WeekDayHeader, completion: @escaping (Bool) -> ()) {
        if let lh = lastExpandedHeader {
            twoDimensionalEventArray[lh.tag].isExpanded = false
            isExpandedOrNot(view: lh)
            lastExpandedHeader = nil
            
            if selectedView == lh {
                completion(false)
                return
            }
            completion(true)
            return
        }
        completion(true)
        return
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

