//
//  CalenderController.swift
//  PilatesTest
//
//  Created by Leon Helg on 29.08.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit
class CalendarController: UITableViewController {
    
    //MARK: - View Loading
    override func viewDidLoad() {
        view.backgroundColor = .white
        setupNavBar()
    }
    
    //MARK: - setup 
    func setupNavBar() {
        self.navigationItem.title = "Kalender"
    }
    
    //MARK: - Methods
}
