//
//  SearchUserProfilesTV.swift
//  LebensfitFirebase
//
//  Created by Leon Helg on 30.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

class SearchUserProfileTableViewController: UITableViewController {
    //MARK: - Properties & Variables
    var filteredUsers = [User]()
    var users = [User]()
    
    //MARK: - GUI Objects
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter username"
        sb.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(230, 230, 230, 1)
        sb.delegate = self
        sb.sizeToFit()
        return sb
    }()
    
    //MARK: -
    //MARK: - Init & View Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false
    }
    
    func setupNavBar() {
        self.navigationController?.setNavigationBarDefault()
        self.navigationItem.title = "Freunde Finden"
//        self.navigationController?.navigationItem.backBarButtonItem?.title = "Zurück"
//        navigationController?.navigationBar.addSubview(searchBar)
//        let navBar = self.navigationController?.navigationBar
//        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        self.navigationItem.titleView = searchBar
    }
    
    func setupTableView() {
        tableView?.backgroundColor = .white
        tableView.delegate            = self
        tableView.dataSource          = self
        tableView.register(UserTVCell.self, forCellReuseIdentifier: UserTVCell.reuseIdentifier)
        tableView.alwaysBounceVertical = true
        tableView.keyboardDismissMode = .onDrag
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
    
    //MARK: - Methods
    func gotoProfile(clickedUID: String) {
        let selectedProfile     = ProfileController()
        selectedProfile.userId  = clickedUID
        DispatchQueue.main.async( execute: {
            self.navigationController?.pushViewController(selectedProfile, animated: true)
        })
    }
}

//MARK: Tableviewdelegate
extension SearchUserProfileTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let id = filteredUsers[indexPath.row].uid else { return }
        gotoProfile(clickedUID: id)
    }
}

//MARK: Tableviewdatasource
extension SearchUserProfileTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row     = tableView.dequeueReusableCell(withIdentifier: UserTVCell.reuseIdentifier, for: indexPath) as! UserTVCell
        //TODO: don't just pass the user.. fill the rows elements from here
        row.user    = filteredUsers[indexPath.row]
        row.confBounds()
        return row
    }
}

extension SearchUserProfileTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = self.users.filter { (user) -> Bool in
                return user.username?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
