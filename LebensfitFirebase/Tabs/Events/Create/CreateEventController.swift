//
//  CreateEvent.swift
//  LebensfitFirebase
//
//  Created by Leon on 24.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

class CreateEventController: UIViewController {
    //MARK: - Properties & Variables
    
    //MARK: - GUI Objects
    
    //MARK: - Init & View Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = LebensfitSettings.Colors.basicBackColor
        setupNavBar()
        setupViews()
        confBounds()
    }
    
    //MARK: - Setup
    func setupNavBar() {
        self.navigationItem.title = "Event erstellen"
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    func setupViews() {
        //TODO:
    }
    
    func confBounds(){
        //TODO:
    }
    
    //MARK: - Methods
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Do not change Methods
}
