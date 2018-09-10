//
//  WeekView.swift
//  LebensfitFirebase
//
//  Created by Leon on 06.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

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
    
    var twoDimensionalArray = [
        ExpandableNames(isExpanded: false, names: ["Amy", "Bill", "Zack", "Steve", "Jack", "Jill", "Mary"]),
        ExpandableNames(isExpanded: false, names: ["Carl", "Chris", "Christina", "Cameron"]),
        ExpandableNames(isExpanded: false, names: ["David", "Dan"]),
        ExpandableNames(isExpanded: false, names: ["Patrick", "Patty"]),
        ]
    var parentVC: TerminController?
    
    //MARK: - GUI Objects
    let calendarTableView: UITableView = {
        let ctv = UITableView()
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
        setupValues()
        setupTableView()
    }
    
    
    //MARK: - Setup
    func setupTableView() {
        calendarTableView.delegate = self
        calendarTableView.dataSource = self
        calendarTableView.register(EventTableCell.self, forCellReuseIdentifier: EventTableCell.reuseIdentifier)
        calendarTableView.register(WeekDayHeader.self, forHeaderFooterViewReuseIdentifier: WeekDayHeader.reuseIdentifier)
        calendarTableView.tintColor = .white
        calendarTableView.separatorStyle = .none
    }
    
    func setupValues() {
        currentYear = Calendar.current.component(.year, from: presentDate)
        currentMonth = Calendar.current.component(.month, from: presentDate)
        currentWeek = Calendar.current.component(.weekOfYear, from: presentDate)
        currentDayDate = Calendar.current.component(.day, from: presentDate)
        currentWeekDayIndex = Calendar.current.component(.weekday, from: presentDate).formatedWeekDay
        todaysDate = Date()
        
    }
    
    func setupViews() {
        addSubview(weekOverView)
        weekOverView.delegate = self
        addSubview(calendarTableView)
    }
    
    func confBounds() {
        weekOverView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 35)
        calendarTableView.anchor(top: weekOverView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //setupBotton()
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
        if section < twoDimensionalArray.count {
            if !twoDimensionalArray[section].isExpanded{
                return 0
            }
            return twoDimensionalArray[section].names.count
        } else {
            return 0
        }
    }
    
    //MARK: Tablecells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventTableCell.reuseIdentifier, for: indexPath) as! EventTableCell
        let name = twoDimensionalArray[indexPath.section].names[indexPath.row]
        cell.titleLabel.text = name

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
    
    
    //MARK: - Methods
    @objc func handleHeaderTap(sender: UITapGestureRecognizer) {
        let selectedView = sender.view as! WeekDayHeader
        let section = selectedView.tag
        if section < twoDimensionalArray.count {
            twoDimensionalArray[section].isExpanded = !twoDimensionalArray[section].isExpanded
        } else {
            selectedView.shake()
        }
        
        print(selectedView.myDate)
        isExpandedOrNot(view: selectedView)
    }
    
    func isExpandedOrNot(view: WeekDayHeader) {
        if view.tag < twoDimensionalArray.count {
            let isExpanded = twoDimensionalArray[view.tag].isExpanded
            setValuesOfHeader(isExpanded: isExpanded, section: view.tag, headerView: view)
        } else {
            view.chevronLabel.textColor = CalendarSettings.Colors.disabled
        }
    }
    
    //creates the index paths out of our array. passed is the section
    func makeIndexPathArray(section: Int) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for row in twoDimensionalArray[section].names.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        return indexPaths
    }
    
    func expandHeader(section: Int) {
        twoDimensionalArray[section].isExpanded = true
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
            newHeaderView.chevronLabel.text = "⌄"
            newHeaderView.dayLabel.textColor = CalendarSettings.Colors.darkRed
            newHeaderView.chevronLabel.textColor = CalendarSettings.Colors.darkRed
            newHeaderView.isSelectedMethod(selected: true)
            newHeaderView.isSelected = true
            if numberOfRows == 0 {
                calendarTableView.insertRows(at: indexPaths, with: .fade)
            }
            
        } else {
            newHeaderView.chevronLabel.text = "›"
            newHeaderView.dayLabel.textColor = .black
            newHeaderView.chevronLabel.textColor = .black
            newHeaderView.isSelectedMethod(selected: false)
            newHeaderView.isSelected = false
            if numberOfRows != 0 {
                calendarTableView.deleteRows(at: indexPaths, with: .fade)
            }
        }
    }
    
    func clearAllHeaders() {
        let numb = numberOfSections(in: calendarTableView)
        var i = 0
        while i < numb && i < twoDimensionalArray.count {
            setValuesOfHeader(isExpanded: false, section: i, headerView: nil)
            i += 1
        }
    }
    
    //MARK: Protokol
    func didChangeWeek(week: Int, year: Int) {
        //calculates the new dates based on old and new week
        let valuue = (week-currentWeek)*7
        presentDate = presentDate.thisDate(value: valuue)
        
        //Make all headers unexpand and in its default state
        for var i in 0..<twoDimensionalArray.count {
            twoDimensionalArray[i].isExpanded = false
            i += 1
        }
        clearAllHeaders()
        setnewWeekValues(week: week, year: year)
        
        //Block user from going to the past months
        let calendar = Calendar.current
        let thisWeek = calendar.component(.weekOfYear, from: Date.init(timeIntervalSinceNow: 0))
        weekOverView.previousWeekButton.isEnabled = !(currentWeek == thisWeek && currentYear == presentYear)
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
            self.weekOverView.setValues(week: self.currentWeek, Year: self.currentYear)
        })
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
