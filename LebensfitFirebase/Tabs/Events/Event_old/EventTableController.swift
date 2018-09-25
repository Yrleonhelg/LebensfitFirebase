//
//  EventTableController.swift
//  LebensfitFirebase
//
//  Created by Leon on 06.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

struct ExpandableNames {
    
    var isExpanded: Bool
    let names: [String]
    
}


class EventTableController: UITableViewController {
    //MARK: - Properties & Variables
    var weekday: String?
    var date: String?
    var month: String?
    
    var selectedIndexPath : IndexPath?
    var deselectedIndexPath : IndexPath?
    
    //MARK: - GUI Objects
    
    //MARK: - Init & View Loading
    init(weekday: String, date: String, month: String) {
        self.weekday = weekday
        self.date = date
        self.month = month
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        setupTableView()
    }
    
    //MARK: - Setup
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
    }
    
    func setupNavBar() {
       self.navigationItem.title = "Tag"
    }
    
   //Amount of Accordions
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    //HEight of the accordians
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    //Title of them
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
    //View of them
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor.blue
        
        return vw
    }
    
    //Child
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        let name = "test"
        
        cell.textLabel?.text = name
        
        return cell
    }
    
    //MARK: - Methods
    
    //MARK: - Do not change Methods
}
