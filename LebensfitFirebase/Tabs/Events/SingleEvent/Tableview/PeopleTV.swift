//
//  TeilnehmerController.swift
//  LebensfitFirebase
//
//  Created by Leon on 12.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit
import Firebase

protocol peopleRowClicked: Any {
    func gotoProfile(clickedUID: String)
}
protocol finishedLoadingParticipants: Any {
    func finishedLoadingParticipants()
}

class PeopleTableView: UIView, ReusableView {
    
    //MARK: - Properties & Variables
    var delegatePRC: peopleRowClicked?
    var delegateFLP: finishedLoadingParticipants?
    
    var myEvent: Event
    var users: [User]! = [User]()

    var finishedLoading: Bool = false
    var padding: CGFloat = 15+25+5
    var height: CGFloat = 60
    
    //MARK: - GUI Objects
    let peopleTableView: UITableView = {
        let tableview = UITableView()
        return tableview
    }()
    
    let peopleLabel: UILabel = {
        let label       = UILabel()
        label.font      = UIFont.systemFont(ofSize: 20)
        label.text      = "Label:"
        label.textColor = .black
        return label
    }()
    
    //MARK: - Init & View Loading
    init(frame: CGRect, event: Event) {
        self.myEvent = event
        super.init(frame: frame)
        self.backgroundColor = LebensfitSettings.Colors.basicBackColor
        setupTableView()
        setupViews()
    }
    
    //MARK: - Setup
    func setupTableView() {
        peopleTableView.delegate      = self
        peopleTableView.dataSource    = self
        peopleTableView.register(TeilnehmerTVCell.self, forCellReuseIdentifier: TeilnehmerTVCell.reuseIdentifier)
        peopleTableView.tintColor     = .white
    }
    
    func setupViews() {
        addSubview(peopleLabel)
        addSubview(peopleTableView)
    }
    
    func removeViews() {
        peopleTableView.removeFromSuperview()
        peopleLabel.removeFromSuperview()
    }
    
    func confBounds(){
        peopleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 25)
        peopleTableView.anchor(top: peopleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        padding = 15+25+5
    }
    
    //MARK: - Methods
    func loadUsers() {
        setNeedsUpdateConstraints()
        if users.count == 0 {
            removeViews()
            padding = 0
        } else {
            setupViews()
        }
        self.updateConstraints()
        delegateFLP?.finishedLoadingParticipants()
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Extensions
//MARK: -
//MARK: - TVDataSource
extension PeopleTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row     = tableView.dequeueReusableCell(withIdentifier: TeilnehmerTVCell.reuseIdentifier, for: indexPath) as! TeilnehmerTVCell
        row.user    = users[indexPath.row]
        row.confBounds()
        return row
    }
}

//MARK: - TVDelegate
extension PeopleTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let id = users[indexPath.row].uid else { return }
        delegatePRC?.gotoProfile(clickedUID: id)
    }
    
}
