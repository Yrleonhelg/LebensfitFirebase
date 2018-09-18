//
//  WeekViewExtensionMethods.swift
//  LebensfitFirebase
//
//  Created by Leon on 12.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

extension WeekView {
    
    //MARK: - Reload
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
    
    
    //MARK: - Header
    func isExpandedOrNot(view: WeekDayHeader) {
        if view.tag < twoDimensionalEventArray.count {
            let isExpanded = twoDimensionalEventArray[view.tag].isExpanded
            setValuesOfHeader(isExpanded: isExpanded, section: view.tag, headerView: view)
        } else {
            view.chevronLabel.textColor = CalendarSettings.Colors.disabled
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
            newHeaderView.dayLabel.textColor        = CalendarSettings.Colors.darkRed
            newHeaderView.chevronLabel.textColor    = CalendarSettings.Colors.darkRed
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
            let currentDay              = mondayOfPresentWeek.thisDate(value: x)
            var eventsToAddForThatDay   = [Event]()
            
            for i in 0..<lengthOfArray {
                let event                   = parent.eventArray[i]
                guard let eventStartTime    = event.eventStartingDate else { return }
                //let isSameDay               = Calendar.current.isDate(currentDay, inSameDayAs: eventStartTime)
                //if isSameDay {
                    //eventsToAddForThatDay.append(event)
                //}
            }
            twoDimensionalEventArray.append(expandableEvent(isExpanded: false, events: eventsToAddForThatDay))
        }
    }
}
