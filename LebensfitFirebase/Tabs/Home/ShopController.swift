//
//  HomeController.swift
//  PilatesTest
//
//  Created by Leon Helg on 29.08.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

class ShopController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: - View Loading
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        setupNavBar()
        setupCollectionView()
    }
    
    //MARK: - Setup
    func setupNavBar() {
        self.navigationItem.title = "Home"
    }
    
    func setupCollectionView() {
        collectionView?.backgroundColor = UIColor(white: 1, alpha: 1)
        collectionView?.register(ActivityCell.self, forCellWithReuseIdentifier: ActivityCell.reuseIdentifier)
        collectionView?.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
    }
    
    //MARK: - Collectionview
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivityCell.reuseIdentifier, for: indexPath) as! ActivityCell
        cell.colorView.backgroundColor = UIColor.rgb(226, 48, 47, 1)
        cell.iconView.image = UIImage(named: "youtube-icon")
        cell.activityLabel.text = "Videos"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = CGFloat(collectionView.frame.width / 2.05)
        let cellHeight = CGFloat(cellWidth*0.9)
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
