//
//  EventController.swift
//  LebensfitFirebase
//
//  Created by Leon on 05.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit
import EventKit

class EventController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    //MARK: - Properties & Variables
    var weekday: String?
    var date: String?
    var month: String?
    
    var selectedIndexPath : IndexPath?
    
    //MARK: - GUI Objects
    
    //MARK: - Init & View Loading
    init(weekday: String, date: String, month: String) {
        let layoutUsing = UICollectionViewFlowLayout()
        self.weekday = weekday
        self.date = date
        self.month = month
        super.init(collectionViewLayout: layoutUsing)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        setupNavBar()
    }
    
    //MARK: - Setup
    func setupCollectionView() {
        collectionView?.delegate=self
//        collectionView.dataSource=self
        collectionView?.register(EventCell.self, forCellWithReuseIdentifier: EventCell.reuseIdentifier)
        collectionView?.backgroundColor = .white
    }
    
    func setupNavBar() {
        self.navigationItem.title = "Tag"
    }
    
    //MARK: - Collectionview
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat
        if indexPath == selectedIndexPath {
            height = EventCell.expandedHeight
        } else {
            height = EventCell.smallHeight
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let eventCell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.reuseIdentifier, for: indexPath) as! EventCell
        eventCell.changeToSmall()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let eventCell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.reuseIdentifier, for: indexPath) as! EventCell
        
        if indexPath == selectedIndexPath {
            eventCell.changeToExpanded()
            selectedIndexPath = nil
        }
        else {
            eventCell.changeToSmall()
        }
        
        return eventCell
    }
    
    //MARK: - Methods
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
