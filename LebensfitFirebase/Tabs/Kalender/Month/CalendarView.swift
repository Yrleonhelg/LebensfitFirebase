//
//  CalendarView.swift
//  LebensfitFirebase
//
//  Created by Leon on 05.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

class CalendarView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MonthViewDelegate {
    
    //MARK: - Properties & Variables
    var numOfDaysInMonth        = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonthIndex: Int  = 0
    var currentYear: Int        = 0
    var presentMonthIndex       = 0
    var presentYear             = 0
    var todaysDate              = 0
    var todayDayToPresentDay    = 0
    var presentDate             = Date()
    var firstWeekDayOfMonth     = 0   //(Sunday-Saturday 1-7
    var currentWeekDay          = Calendar.current.component(.weekday, from: Date())
    var parentVC: TerminController?
    
    //MARK: - GUI Objects
    let calendarCollectionView: UICollectionView = {
        let layout          = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let mcv             = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        mcv.showsHorizontalScrollIndicator = false
        mcv.backgroundColor = UIColor.clear
        mcv.allowsMultipleSelection = false
        return mcv
    }()
    
    let monthOverView: MonthOverView = {
        let mv = MonthOverView()
        return mv
    }()
    
    let weekdayView: WeekdayView = {
        let wv = WeekdayView()
        return wv
    }()
    
    //MARK: - Init & View Loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        setupValues()
        setupViews()
        confBounds()
        setupCollectionView()
    }
    
    convenience init(theme: currentTheme) {
        self.init()
        if theme == .dark {
            CalendarSettings.Style.themeDark()
        } else {
            CalendarSettings.Style.themeLight()
        }
         presentDate = Date()
        setupValues()
        setupViews()
        confBounds()
        setupCollectionView()
    }
    
    
    //MARK: - Setup
    func setupValues() {
        currentMonthIndex       = Calendar.current.component(.month, from: Date())
        currentYear             = Calendar.current.component(.year, from: Date())
        todaysDate              = Calendar.current.component(.day, from: Date())
        firstWeekDayOfMonth     = getFirstWeekDay()
       
        
        //In Schaltjahren hat der Februar einen Tag mehr
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex-1] = 29
        }
        presentMonthIndex       = currentMonthIndex
        presentYear             = currentYear
    }
    
    func setupCollectionView() {
        calendarCollectionView.delegate     = self
        calendarCollectionView.dataSource   = self
        calendarCollectionView.register(DateCell.self, forCellWithReuseIdentifier: DateCell.reuseIdentifier)
    }
    
    func setupViews() {
        addSubview(monthOverView)
        monthOverView.delegate = self
        addSubview(weekdayView)
        addSubview(calendarCollectionView)
    }
    
    func confBounds(){
        monthOverView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 35)
        weekdayView.anchor(top: monthOverView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        calendarCollectionView.anchor(top: weekdayView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    
    //MARK: - Collectionview
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfDaysInMonth[currentMonthIndex-1] + firstWeekDayOfMonth - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCell.reuseIdentifier, for: indexPath) as! DateCell
        cell.backgroundColor=UIColor.clear
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            cell.isHidden = true
        } else {
            let calcDate = indexPath.row-firstWeekDayOfMonth+2
            cell.isHidden=false
            cell.dayLabel.text="\(calcDate)"
            let valuee = (calcDate-todaysDate + todayDayToPresentDay)
            cell.myDate = Date().thisDate(value: valuee)
            
            if calcDate < todaysDate && currentYear == presentYear && currentMonthIndex == presentMonthIndex {
                cell.isUserInteractionEnabled=false
                cell.dayLabel.textColor = UIColor.lightGray
            } else if calcDate == todaysDate && currentYear == presentYear && currentMonthIndex == presentMonthIndex{
                cell.selectionView.layer.borderColor = CalendarSettings.Colors.darkRed.cgColor
                cell.selectionView.layer.borderWidth = 1
                cell.isUserInteractionEnabled=true
                cell.dayLabel.textColor = CalendarSettings.Style.activeCellLblColor
                //print("TODAY")
            } else {
                cell.isUserInteractionEnabled=true
                cell.dayLabel.textColor = CalendarSettings.Style.activeCellLblColor
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DateCell else { return }
        cell.selectionView.backgroundColor = CalendarSettings.Colors.darkRed
        cell.dayLabel.textColor = CalendarSettings.Style.activeCellLblColorHighlighted
        
        //show event menu if double clicked on a cell
        if !cell.cellSelected {
            cell.cellSelected = true
        } else {
            //TODO: Delegate back to controller and navigate from there
            guard let parent = parentVC else { return }
            parent.gotoDay(date: cell.myDate)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DateCell else { return }
        cell.selectionView.backgroundColor = UIColor.clear
        cell.cellSelected = false
        cell.dayLabel.textColor = CalendarSettings.Style.activeCellLblColor
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/7 - 8
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    
    //MARK: - Methods
    func changeTheme() {
        calendarCollectionView.reloadData()
        
        monthOverView.currentMonthLabel.textColor = CalendarSettings.Style.monthViewLblColor
        monthOverView.nextMonthButton.setTitleColor(CalendarSettings.Style.monthViewBtnRightColor, for: .normal)
        monthOverView.previousMonthButton.setTitleColor(CalendarSettings.Style.monthViewBtnLeftColor, for: .normal)
        
        for i in 0..<7 {
            (weekdayView.stackView.subviews[i] as! UILabel).textColor = CalendarSettings.Style.weekdaysLblColor
        }
    }
    
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
        //return day == 7 ? 1 : day
        return day
    }
    
    func didChangeMonth(monthIndex: Int, year: Int) {
        var valuue: Int = 0
        if (monthIndex >= currentMonthIndex && (monthIndex != 11 || year == currentYear)) || (year > currentYear && monthIndex < currentMonthIndex) {
            valuue = 1
        } else {
            valuue = -1
        }
        
        currentMonthIndex = monthIndex+1
        currentYear = year
        
        
        //In Schaltjahren hat der Februar einen Tag mehr
        if monthIndex == 1 {
            if currentYear % 4 == 0 {
                numOfDaysInMonth[monthIndex] = 29
            } else {
                numOfDaysInMonth[monthIndex] = 28
            }
        }
        
        //Adds the amount of days in the month to the current date
        todayDayToPresentDay += (numOfDaysInMonth[monthIndex.formattedMonthIndex])*valuue

        firstWeekDayOfMonth = getFirstWeekDay()
        deselectAllCells()
        
        DispatchQueue.main.async( execute: {
            self.calendarCollectionView.reloadData()
        })
        
        //Block user from going to the past months
        monthOverView.previousMonthButton.isEnabled = !(currentMonthIndex == presentMonthIndex && currentYear == presentYear)
    }
    
    func deselectAllCells() {
        let cells = self.calendarCollectionView.visibleCells as! [DateCell]
        for cell in cells {
            cell.cellSelected = false
            cell.selectionView.backgroundColor = .clear
            cell.selectionView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
