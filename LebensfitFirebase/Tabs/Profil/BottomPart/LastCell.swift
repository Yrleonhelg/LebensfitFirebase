//
//  LastCell.swift
//  LebensfitFirebase
//
//  Created by Leon on 28.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit
import Firebase

class LastCell: UITableViewCell, ReusableView {
    //MARK: - Properties & Variables
    //MARK: - GUI Objects
    
    let plusImageView: UIImageView = {
        let view              = UIImageView()
        view.contentMode      = .scaleAspectFit
        view.clipsToBounds    = true
        view.image            = UIImage(named: "plus_glow")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    

    //MARK: - Init & View Loading
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.layer.borderWidth = 2
        setupViews()
    }
    
    //MARK: - Setup
    func setupViews() {
        addSubview(plusImageView)
        plusImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        plusImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        plusImageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
