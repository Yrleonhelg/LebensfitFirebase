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
        unexpandAllHeaders()
        setupValues()
        delegate?.weekChanged()
        setnewWeekValues(week: week, year: year)
        
        //Block user from going to the past months
        let thisWeek = Calendar.current.component(.weekOfYear, from: Date.init(timeIntervalSinceNow: 0))
        weekOverView.previousWeekButton.isEnabled = !(currentWeek == thisWeek && currentYear == presentYear)
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
        let header            = tableView.dequeueReusableHeaderFooterView(withIdentifier: WeekDayHeader.reuseIdentifier) as! WeekDayHeader
        setDefaultValuesForHeader(header: header, section: section)
        
        //Calculate Date and Highlight if today
        let dayDifference = -(currentWeekDayIndex - (section))
        if section == currentWeekDayIndex && presentDate.noon == todaysDate.noon {
            header.myDate         = todaysDate
            header.addDot()
        } else {
            header.myDate         = presentDate.addDaysToToday(amount: dayDifference)
        }
        header.dateLabel.text = header.myDate.formatDateddMMMyyyy()
        return header
    }
    
    func setDefaultValuesForHeader(header: WeekDayHeader, section: Int) {
        //Click Recognizer
        let headerTap       = UITapGestureRecognizer(target: self, action: #selector(self.handleHeaderTap(sender:)))
        headerTap.delegate  = self
        header.addGestureRecognizer(headerTap)
        
        //Default Values
        header.tag            = section
        header.isSelected     = false
        header.dayLabel.text  = WeekDays[section]
        header.removeDot()
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

