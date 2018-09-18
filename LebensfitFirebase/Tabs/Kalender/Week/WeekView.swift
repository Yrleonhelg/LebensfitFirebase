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

class WeekView: UIView, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, WeekViewDelegate {
    
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
        self.backgroundColor    = UIColor.white
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
        calendarTableView.tintColor         = .white
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
        mondayOfPresentWeek = presentDate.thisDate(value: -currentWeekDayIndex)
        todaysDate          = Date()
        print(mondayOfPresentWeek)
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
    
    //MARK: - Tableview
    //MARK: Header
    func numberOfSections(in tableView: UITableView) -> Int {
        return WeekDays.count
    }
    
    //HEight of the accordions
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view            = tableView.dequeueReusableHeaderFooterView(withIdentifier: WeekDayHeader.reuseIdentifier) as! WeekDayHeader
        let headerTap       = UITapGestureRecognizer(target: self, action: #selector(self.handleHeaderTap(sender:)))
        headerTap.delegate  = self
        view.addGestureRecognizer(headerTap)
        view.tag            = section
        view.isSelected     = false
        view.dayLabel.text  = WeekDays[section]
        
        
        //Calculate Date and Highlight if today
        let valuee = -(currentWeekDayIndex - (section))
        if section == currentWeekDayIndex && presentDate.noon == todaysDate.noon {
            view.confBoundsToday()
            view.isCurrentDay   = true
            view.myDate         = todaysDate
        } else {
            view.confBoundsDefault()
            view.isCurrentDay   = false
            view.myDate         = presentDate.thisDate(value: valuee)
            view.removeDot()
        }
        
        //Set the date and check if the Header is expanded and should display content
        view.setDate()
        isExpandedOrNot(view: view)
        
        return view
    }
    
    //returns the number of cells for each header if the header is on mode expanded
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < twoDimensionalEventArray.count {
            if !twoDimensionalEventArray[section].isExpanded{
                return 0
            }
            return twoDimensionalEventArray[section].events.count
        } else {
            return 0
        }
    }
    
    //MARK: Tablecells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventTableCell.reuseIdentifier, for: indexPath) as! EventTableCell
        if let name = twoDimensionalEventArray[indexPath.section].events[indexPath.row].eventName {
             cell.titleLabel.text = name
        }
        let id = twoDimensionalEventArray[indexPath.section].events[indexPath.row].eventID
        cell.eventId = id
        
        if let start = twoDimensionalEventArray[indexPath.section].events[indexPath.row].eventStartingDate {
            if let finish = twoDimensionalEventArray[indexPath.section].events[indexPath.row].eventFinishingDate {
                cell.timeLabel.text = "\(start.getHourAndMinuteAsStringFromDate() ) bis \(finish.getHourAndMinuteAsStringFromDate() )"
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //goes to the event if a row is clicked. uses the array instead of the cell because bugs
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let parent = parentVC else { return }
        let id = twoDimensionalEventArray[indexPath.section].events[indexPath.row].eventID
        parent.gotoEvent(eventID: id)
    }
    
    
    //MARK: - Methods
    @objc func handleHeaderTap(sender: UITapGestureRecognizer) {
        let selectedView = sender.view as! WeekDayHeader
        let section = selectedView.tag
        
        if section < twoDimensionalEventArray.count && !twoDimensionalEventArray[section].events.isEmpty {
            manageLastHeader(selectedView: selectedView, completion: {
                yesorno in
                print(yesorno)
                if yesorno {
                    self.twoDimensionalEventArray[section].isExpanded = !self.twoDimensionalEventArray[section].isExpanded
                    self.isExpandedOrNot(view: selectedView)
                }
            })
        } else {
            selectedView.shake()
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
    
    
    //MARK: Protokol
    func didChangeWeek(week: Int, year: Int) {
        //calculates the new dates based on old and new week
        let valuue = (week-currentWeek)*7
        presentDate = presentDate.thisDate(value: valuue)
        
        //Make all headers unexpand and in its default state
        for var i in 0..<twoDimensionalEventArray.count {
            twoDimensionalEventArray[i].isExpanded = false
            i += 1
        }
        unexpandAllHeaders()
        setupValues()
        setupArray()
        setnewWeekValues(week: week, year: year)
        
        //Block user from going to the past months
        let calendar = Calendar.current
        let thisWeek = calendar.component(.weekOfYear, from: Date.init(timeIntervalSinceNow: 0))
        weekOverView.previousWeekButton.isEnabled = !(currentWeek == thisWeek && currentYear == presentYear)
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
