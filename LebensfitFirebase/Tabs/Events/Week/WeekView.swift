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

protocol weekViewToTerminController: Any {
    func gotoEvent(eventID: Int32)
    func getEventArray() -> [Event]
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
    var lastExpandedSection: Int?
    
    var twoDimensionalEventArray    = [expandableEvent]()
    var parentVC: TerminController?
    var delegate: weekViewToTerminController?
    
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
    
    //Loops trough the parents array of events and puts the ones that are in the displayed week in an array (sorted by day).
    func setupArray() {
        twoDimensionalEventArray.removeAll()
        let eventArray          = (delegate?.getEventArray()) ?? [Event]()
        let numberOfWeekdays    = 7
        
        for x in 0..<numberOfWeekdays {
            let currentDay              = mondayOfPresentWeek.addDaysToToday(amount: x)
            var eventsToAddForThatDay   = [Event]()
            
            for i in 0..<eventArray.count {
                let event                   = eventArray[i]
                guard let eventStartTime    = event.eventStartingDate else { return }
                let isSameDay               = Calendar.current.isDate(currentDay, inSameDayAs: eventStartTime as Date)
                if isSameDay {
                    eventsToAddForThatDay.append(event)
                }
            }
            twoDimensionalEventArray.append(expandableEvent(isExpanded: false, events: eventsToAddForThatDay))
        }
    }
    
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
            self.weekOverView.setWeekAndYearValues(week: self.currentWeek, Year: self.currentYear)
        })
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Gesture Recognizer
extension WeekView: UIGestureRecognizerDelegate {
    @objc func handleHeaderTap(sender: UITapGestureRecognizer) {
        //1. Get header and section of the tapped Header
        let selectedHeader = sender.view as! WeekDayHeader
        guard let section = sender.view?.tag else { return }
        
        startSequenceOfEventsToExpandHeader(section: section, header: selectedHeader)
    }
}


//MARK: - Accordion
//This Extension handles everything that belongs to the functionality of expanding and unexpanding the headers.
extension WeekView {
    
    func startSequenceOfEventsToExpandHeader(section: Int, header: WeekDayHeader?) {
        //2. check if the array has data and can expand without an error.. else -> shake and return
        if checkIfSectionCanBeExpanded(section: section) {
            //3. unexpand all headers and hide their rows
            unexpandAllHeaders()
            //4. check if clicked section was the last opened section.. yes -> return
            if sectionWasLastOpenedSection(section: section) {
                lastExpandedSection = nil
                return
            } else {
                //5. Expand clicked header and show it's rows.
                expandHeaderForSection(section: section)
                showRowsForSection(section: section)
                return
            }
        } else {
            if let selectedHeader = header {
                selectedHeader.shake()
            }
            return
        }
    }
    
    /**
     First call before headers (un)expand.
     - returns: Boolean if the appropriate array has data at the section it should expand
     - parameter section: Section of the clicked Header (0-6)
     */
    func checkIfSectionCanBeExpanded(section: Int) -> Bool {
        if section < twoDimensionalEventArray.count && !twoDimensionalEventArray[section].events.isEmpty {
            return true
        }
        return false
    }
    
    /**
     Unexpands all Headers and hides the belonging rows.
     */
    func unexpandAllHeaders() {
        let numberOfSections = calendarTableView.numberOfSections
        for i in 0..<numberOfSections {
            hideRowsForSection(section: i)
            unexpandHeaderForSection(section: i)
        }
    }
    
    /**
     Unexpands a Header
     - parameter section: Section of the Header which will unexpand (0-6)
     */
    func unexpandHeaderForSection(section: Int) {
        twoDimensionalEventArray[section].isExpanded = false
        let header = calendarTableView.headerView(forSection: section) as! WeekDayHeader
        header.chevronLabel.text         = "›"
        header.dayLabel.textColor        = .black
        header.chevronLabel.textColor    = .black
        header.isSelected                = false
    }
    
    /**
     Expands a Header
     - parameter section: Section of the Header which will expand (0-6)
     */
    func expandHeaderForSection(section: Int) {
        let header = calendarTableView.headerView(forSection: section) as! WeekDayHeader
        header.chevronLabel.text         = "⌄"
        header.dayLabel.textColor        = LebensfitSettings.Colors.basicTintColor
        header.chevronLabel.textColor    = LebensfitSettings.Colors.basicTintColor
        header.isSelected                = true
        lastExpandedSection              = section
    }    
    
    /**
     Helper method which gives the index Path of all rows for a section
     - returns: Array of Indexpaths for the rows in the section
     - parameter section: Section of the rows we need (0-6)
     */
    func getRowsForSection(section: Int) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for row in twoDimensionalEventArray[section].events.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        return indexPaths
    }
    
    /**
     Helper method which shows if the clicked section parameter is the last expanded section
     - returns: Boolean if the clicked and last Expanded Section are equal
     - parameter section: Section of the clicked Header (0-6)
     */
    func sectionWasLastOpenedSection(section: Int) -> Bool {
        guard let lastSection = lastExpandedSection else { return false }
        if section == lastSection {
            return true
        } else {
            return false
        }
    }
    
    /**
     Hides rows of a section
     - parameter section: Section of the Rows which will hide (0-6)
     */
    func hideRowsForSection(section: Int) {
        let indexPaths = getRowsForSection(section: section)
        let numberOfRows = calendarTableView.numberOfRows(inSection: section)
        
        if numberOfRows != 0 {
            twoDimensionalEventArray[section].isExpanded = false
            calendarTableView.beginUpdates()
            calendarTableView.deleteRows(at: indexPaths, with: .fade)
            calendarTableView.endUpdates()
        }
    }
    
    /**
     Shows rows of a section
     - parameter section: Section of the Rows which will appear (0-6)
     */
    func showRowsForSection(section: Int) {
        let indexPaths = getRowsForSection(section: section)
        let numberOfRows = calendarTableView.numberOfRows(inSection: section)
        
        if numberOfRows == 0 {
            twoDimensionalEventArray[section].isExpanded = true
            calendarTableView.beginUpdates()
            calendarTableView.insertRows(at: indexPaths, with: .fade)
            calendarTableView.endUpdates()
        }
    }
}
