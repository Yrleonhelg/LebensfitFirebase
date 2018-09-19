//
//  TeilnehmerController.swift
//  LebensfitFirebase
//
//  Created by Leon on 12.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit
import Firebase

class PeopleTableView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Properties & Variables
    var parentVC: SingleEventViewController?
    var users: [User]! = [User]()
    var sortedUsers: [User]! = [User]()
    
    //MARK: - GUI Objects
    let peopleTableView: UITableView = {
        let ctv = UITableView()
        return ctv
    }()
    
    //MARK: - Init & View Loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupTableView()
        setupViews()
        confBounds()
    }
    
    //MARK: - Setup
    func setupTableView() {
        peopleTableView.delegate      = self
        peopleTableView.dataSource    = self
        peopleTableView.register(TeilnehmerTVCell.self, forCellReuseIdentifier: TeilnehmerTVCell.reuseIdentifier)
        peopleTableView.tintColor     = .white
    }
    
    func setupViews() {
        addSubview(peopleTableView)
    }
    
    func confBounds(){
        peopleTableView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    //MARK: - Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row     = tableView.dequeueReusableCell(withIdentifier: TeilnehmerTVCell.reuseIdentifier, for: indexPath) as! TeilnehmerTVCell
        row.user    = users[indexPath.row]
        row.confBounds()
        return row
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let id = users[indexPath.row].uid else { return }
        guard let parent = parentVC else { return }
        parent.gotoProfile(clickedUID: id)
    }
    
    //MARK: - Methods
    
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
