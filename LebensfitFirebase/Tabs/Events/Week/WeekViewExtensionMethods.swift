//
//  WeekViewExtensionMethods.swift
//  LebensfitFirebase
//
//  Created by Leon on 12.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

//MARK: Protokol
extension WeekView: WeekViewDelegate {
    func didChangeWeek(week: Int, year: Int) {
        //calculates the new dates based on old and new week
        let valuue = (week-currentWeek)*7
        presentDate = presentDate.addDaysToToday(amount: valuue)
        
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
}

//MARK: - Gesture Recognizer
extension WeekView: UIGestureRecognizerDelegate {
    @objc func handleHeaderTap(sender: UITapGestureRecognizer) {
        let selectedView = sender.view as! WeekDayHeader
        let section = selectedView.tag
        
        if section < twoDimensionalEventArray.count && !twoDimensionalEventArray[section].events.isEmpty {
            manageLastHeader(selectedView: selectedView, completion: { isLast in
                if isLast {
                    self.twoDimensionalEventArray[section].isExpanded = !self.twoDimensionalEventArray[section].isExpanded
                    self.isExpandedOrNot(view: selectedView)
                }
            })
        } else {
            selectedView.shake()
        }
    }
}

//MARK: - TVDelegate
extension WeekView: UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return WeekDays.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    //returns the number of cells for each header if the header is expanded
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < twoDimensionalEventArray.count {
            if twoDimensionalEventArray[section].isExpanded{
                return twoDimensionalEventArray[section].events.count
            }
        }
        return 0
    }
    
    //height for rows
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //goes to the event if a row is clicked. uses the array instead of the cell because bugs
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let id = twoDimensionalEventArray[indexPath.section].events[indexPath.row].eventID
        delegate?.gotoEvent(eventID: id)
    }
}


//MARK: - TVDataSource
extension WeekView: UITableViewDataSource {
    //Header / Accordion
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
        view.confBounds()
        if section == currentWeekDayIndex && presentDate.noon == todaysDate.noon {
            view.myDate         = todaysDate
            view.addDot()
        } else {
            view.myDate         = presentDate.addDaysToToday(amount: valuee)
            view.removeDot()
        }
        
        //Set the date and check if the Header is expanded and should display content
        view.dateLabel.text = view.myDate.formatDateddMMMyyyy()
        isExpandedOrNot(view: view)
        
        return view
    }
    
    //Rows
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
}

