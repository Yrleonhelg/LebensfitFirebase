//
//  PinnwandStackView.swift
//  LebensfitFirebase
//
//  Created by Leon on 28.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//
import UIKit
import Firebase

struct Pin {
    let forUser: User
    let fromUser: User
    let message: String
    let time: Date
}

class PinnwandStackView: UIStackView {
    
    //MARK: - Properties & Variables
    var user: User?
    var Pins: [Pin] = [Pin]()
    
    //MARK: - GUI Objects
    let ueberMich: UILabel = {
        let label       = UILabel()
        label.font      = UIFont.systemFont(ofSize: 20)
        label.text      = "Leon Helgs Pins:"
        label.textColor = LebensfitSettings.Colors.basicTextColor
        return label
    }()
    
    let pinnwandTableView: UITableView = {
        let tableview = UITableView()
        tableview.layer.borderColor = UIColor.red.cgColor
        tableview.layer.borderWidth = 1
        tableview.backgroundColor = .clear
        tableview.sizeToFit()
        return tableview
    }()
    
    //MARK: -
    //MARK: - Init & View Loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.user = CDUser.sharedInstance.getCurrentUser()
        fillMessages()
        setupStackView()
        setupTableView()
        setupViews()
    }
    
    //MARK: - Setup Methods
    func setupStackView() {
        self.axis           = .vertical
        self.spacing        = 10
        self.alignment      = .fill
        self.distribution   = .fill
    }
    
    func setupTableView() {
        pinnwandTableView.delegate            = self
        pinnwandTableView.dataSource          = self
        pinnwandTableView.register(PinnCell.self, forCellReuseIdentifier: PinnCell.reuseIdentifier)
        pinnwandTableView.register(LastCell.self, forCellReuseIdentifier: LastCell.reuseIdentifier)
        pinnwandTableView.tintColor           = .red
        pinnwandTableView.isScrollEnabled     = false
    }
   
    func setupViews() {
        self.addArrangedSubview(ueberMich)
        self.addArrangedSubview(pinnwandTableView)
    }
    
    //MARK: - Methods
    func calculate() -> CGFloat {
        let labelHeight = ueberMich.frame.height
        let tableviewHeight = 60 * CGFloat(pinnwandTableView.numberOfRows(inSection: 0))
        return labelHeight + tableviewHeight + 10
    }
    
    //TODO: API call
    func fillMessages() {
        guard let user = user else { return }
        let message = "Hallo Welt, ich bin ein Nutzer, ich finde diesen Nutzer sehr interessant. Seine Pilatische Haltung gefällt mir super."
        let message2 = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit"
        
        let pin = Pin(forUser: user, fromUser: user, message: message, time: Date())
        let pin2 = Pin(forUser: user, fromUser: user, message: message2, time: Date())
        Pins = [pin, pin2, pin, pin2, pin]
    }
    
    //MARK: - Do not change Methods
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PinnwandStackView: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Pins.count + 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension PinnwandStackView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < Pins.count {
            let row     = tableView.dequeueReusableCell(withIdentifier: PinnCell.reuseIdentifier, for: indexPath) as! PinnCell
            let pin     = Pins[indexPath.row]
            row.user    = pin.fromUser
            row.messagePreview.text = pin.message
            row.confBounds()
            return row
            
        } else {
            let row     = tableView.dequeueReusableCell(withIdentifier: LastCell.reuseIdentifier, for: indexPath) as! LastCell
            return row
        }
    }
}
