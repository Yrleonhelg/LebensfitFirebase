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
    let monthsShortArr = ["Jan", "Feb", "März", "Apr", "Mai", "Jun", "Jul", "Aug", "Sep", "Okt", "Nov", "Dez"]
    let numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    let WeekDays = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"]
    var currentMonth: Int = 0
    var currentYear: Int = 0
    var currentWeek: Int = 0
    var currentWeekDayIndex: Int = 0
    var currentDayDate: Int = 0
    var todaysDate = Date()
    var presentDate = Date()
    var presentYear = 0
    var mondayOfPresentWeek = Date()
    var lastExpandedHeader: WeekDayHeader?
    var onGoingAnimation = false
    
//    var twoDimensionalArray = [
//        ExpandableNames(isExpanded: false, names: ["Amy", "Bill", "Zack", "Steve", "Jack", "Jill", "Mary"]),
//        ExpandableNames(isExpanded: false, names: ["Carl", "Chris", "Christina", "Cameron"]),
//        ExpandableNames(isExpanded: false, names: ["David", "Dan"]),
//        ExpandableNames(isExpanded: false, names: ["Patrick", "Patty"]),
//        ]
    
    var twoDimensionalEventArray = [expandableEvent]()
    var parentVC: TerminController?
    
    //Loops trough the parents array of events and puts the ones that are in the displayed week in an array (sorted by day).
    func setupArray() {
        guard let parent = parentVC else { return }
        let numberOfWeekdays = 7
        let lengthOfArray = parent.eventArray.count
        
        for x in 0..<numberOfWeekdays {
            let currentDay = mondayOfPresentWeek.thisDate(value: x)
            var eventsToAddForThatDay = [Event]()
            
            for i in 0..<lengthOfArray {
                let event = parent.eventArray[i]
                guard let eventStartTime = event.eventStartingDate else { return }
                let isSameDay = Calendar.current.isDate(currentDay, inSameDayAs: eventStartTime)
                if isSameDay {
                    eventsToAddForThatDay.append(event)
                }
            }
            twoDimensionalEventArray.append(expandableEvent(isExpanded: false, events: eventsToAddForThatDay))
        }
    }
    
    //MARK: - GUI Objects
    let calendarTableView: UITableView = {
        let ctv = UITableView()
        //ctv.frame = .zero
        ctv.translatesAutoresizingMaskIntoConstraints = false
        return ctv
    }()
    
    let weekOverView: WeekOverView = {
        let wv = WeekOverView()
        return wv
    }()
    
    //MARK: - Init & View Loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        presentDate = Date()
        setupTheSetup()
    }
    
    func setupTheSetup() {
        setupTableView()
        setupViews()
        confBounds()
        setupValues()
    }
    
    //MARK: - Setup
    func setupTableView() {
        calendarTableView.delegate = self
        calendarTableView.dataSource = self
        calendarTableView.register(EventTableCell.self, forCellReuseIdentifier: EventTableCell.reuseIdentifier)
        calendarTableView.register(WeekDayHeader.self, forHeaderFooterViewReuseIdentifier: WeekDayHeader.reuseIdentifier)
        calendarTableView.tintColor = .white
        calendarTableView.separatorStyle = .none
        //calendarTableView.layoutIfNeeded()
        
    }
    
    func setupValues() {
        currentYear = Calendar.current.component(.year, from: presentDate)
        currentMonth = Calendar.current.component(.month, from: presentDate)
        currentWeek = Calendar.current.component(.weekOfYear, from: presentDate)
        currentDayDate = Calendar.current.component(.day, from: presentDate)
        currentWeekDayIndex = Calendar.current.component(.weekday, from: presentDate).formatedWeekDay
        mondayOfPresentWeek = presentDate.thisDate(value: -currentWeekDayIndex)
        todaysDate = Date()
        setupArray()
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
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: WeekDayHeader.reuseIdentifier) as! WeekDayHeader
        let headerTap = UITapGestureRecognizer(target: self, action: #selector(self.handleHeaderTap(sender:)))
        headerTap.delegate = self
        view.addGestureRecognizer(headerTap)
        view.tag = section
        view.isSelected = false
        view.dayLabel.text = WeekDays[section]
        
        
        //Calculate Date and Highlight if today
        let valuee = -(currentWeekDayIndex - (section))
        if section == currentWeekDayIndex && presentDate.noon == todaysDate.noon {
            view.confBoundsToday()
            view.isCurrentDay = true
            view.myDate = todaysDate
        } else {
            view.confBoundsDefault()
            view.isCurrentDay = false
            view.myDate = presentDate.thisDate(value: valuee)
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
        let name = twoDimensionalEventArray[indexPath.section].events[indexPath.row].eventName
        let start = twoDimensionalEventArray[indexPath.section].events[indexPath.row].eventStartingDate
        let finish = twoDimensionalEventArray[indexPath.section].events[indexPath.row].eventFinishingDate
        let id = twoDimensionalEventArray[indexPath.section].events[indexPath.row].eventID
        
        cell.eventId = id!
        cell.titleLabel.text = name
        cell.timeLabel.text = "\(start?.getHourAndMinuteAsStringFromDate() ?? "0:00") bis \(finish?.getHourAndMinuteAsStringFromDate() ?? "0:00")"


        //Make the divider Line of the last tableview cell bigger
        if calendarTableView.isLast(for: indexPath) {
            cell.isLastMethod(last: true)
        } else {
            cell.isLastMethod(last: false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let parent = parentVC else { return }
        let tvCell = tableView.dequeueReusableCell(withIdentifier: EventTableCell.reuseIdentifier, for: indexPath) as! EventTableCell
        guard let id = tvCell.eventId else { return }
        parent.gotoEvent(eventID: id)
    }
    
    
    //MARK: - Methods
    @objc func handleHeaderTap(sender: UITapGestureRecognizer) {
        let selectedView = sender.view as! WeekDayHeader
        print(selectedView.dayLabel.text)
        
        let section = selectedView.tag
        if section < twoDimensionalEventArray.count && twoDimensionalEventArray[section].events.count != 0{
            if let lastHeader = lastExpandedHeader {
                twoDimensionalEventArray[lastHeader.tag].isExpanded = false
                isExpandedOrNot(view: lastHeader)
            }
            twoDimensionalEventArray[section].isExpanded = !twoDimensionalEventArray[section].isExpanded
        } else {
            selectedView.shake()
        }
        
        isExpandedOrNot(view: selectedView)
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
