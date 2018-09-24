//
//  LoginController.swift
//  LebensfitFirebase
//
//  Created by Leon on 04.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    //MARK: - GUI Objects
    let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Lebensfit"
        label.font = .boldSystemFont(ofSize: 50)
        label.textColor = .white
        return label
    }()
    
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = LebensfitSettings.Colors.basicTintColor
        return view
    }()
    
    let emailTextField: UITextField = {
        let texfield                = UITextField()
        texfield.placeholder        = "Email"
        texfield.backgroundColor    = UIColor(white: 0, alpha: 0.03)
        texfield.borderStyle        = .roundedRect
        texfield.font               = UIFont.systemFont(ofSize: 14)
        texfield.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return texfield
    }()
    
    let passwordTextField: UITextField = {
        let texfield                = UITextField()
        texfield.placeholder        = "Password"
        texfield.isSecureTextEntry  = true
        texfield.backgroundColor    = UIColor(white: 0, alpha: 0.03)
        texfield.borderStyle        = .roundedRect
        texfield.font               = UIFont.systemFont(ofSize: 14)
        texfield.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return texfield
    }()
    
    let loginButton: UIButton = {
        let button                  = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor      = LebensfitSettings.Colors.basicTintColor
        button.layer.cornerRadius   = 5
        button.titleLabel?.font     = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled            = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    let dontHaveAccountButton: UIButton = {
        let button          = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: LebensfitSettings.Colors.basicTintColor
            ]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let view          = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        view.axis         = .vertical
        view.spacing      = 10
        view.distribution = .fillEqually
        return view
    }()
    
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
        navigationController?.isNavigationBarHidden = true
    }
    
    func setupViews() {
        view.addSubview(headerView)
        view.addSubview(headerLabel)
        view.addSubview(stackView)
        view.addSubview(dontHaveAccountButton)
    }
    
    func confBounds(){
        headerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
        headerLabel.anchor(top: nil, left: nil, bottom: headerView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 30, paddingRight: 0, width: 0, height: 0)
        headerLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        
        stackView.anchor(top: headerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 140)
        
        dontHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    }
    
    //MARK: - Methods
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.isEmpty != true &&  passwordTextField.text?.isEmpty != true
        
        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = LebensfitSettings.Colors.basicTintColor.withAlphaComponent(1)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = LebensfitSettings.Colors.basicTintColor.withAlphaComponent(0.6)
        }
    }
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        loginToFireBase(email: email, pw: password)
    }
    
    @objc func handleShowSignUp() {
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
}

