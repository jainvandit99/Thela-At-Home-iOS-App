//
//  SignUpViewController.swift
//  Thela At Home
//
//  Created by Vandit Jain on 12/04/20.
//  Copyright © 2020 jainvandit. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField


class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
    }
    
    func addViews(){
        let backgroundImageView = UIImageView()
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backgroundImageView)
        backgroundImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        backgroundImageView.heightAnchor.constraint(equalToConstant: self.view.frame.height * 0.5).isActive = true
        backgroundImageView.image = UIImage(named: "signInBackground")
        backgroundImageView.contentMode = .scaleAspectFill
        
        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cardView)
        cardView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        cardView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        cardView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        cardView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 20
        cardView.layer.masksToBounds = false
        cardView.clipsToBounds = true
        
        let logInLabel = UILabel()
        logInLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(logInLabel)
        logInLabel.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: 24).isActive = true
        logInLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24).isActive = true
        logInLabel.text = "Sign Up"
        logInLabel.textColor = Colors.secondaryDark
        
        let nameTextField = SkyFloatingLabelTextFieldWithIcon()
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: 24).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: cardView.rightAnchor, constant: -24).isActive = true
        nameTextField.topAnchor.constraint(equalTo: logInLabel.bottomAnchor, constant: 24).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameTextField.placeholder = "  Full Name"
        nameTextField.title = "Full Name"
        nameTextField.textContentType = .emailAddress
        nameTextField.selectedLineColor = Colors.darkGreen
        nameTextField.selectedTitleColor = Colors.darkGreen
        nameTextField.autocapitalizationType = .none
        nameTextField.textColor = Colors.secondaryDark
        nameTextField.placeholderColor = UIColor.lightGray
        nameTextField.iconType = .image
        nameTextField.iconImage = UIImage(named: "name")
        
        
        let emailTextField = SkyFloatingLabelTextFieldWithIcon()
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(emailTextField)
        emailTextField.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: 24).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: cardView.rightAnchor, constant: -24).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailTextField.placeholder = "  Email"
        emailTextField.title = "Email"
        emailTextField.textContentType = .emailAddress
        emailTextField.selectedLineColor = Colors.darkGreen
        emailTextField.selectedTitleColor = Colors.darkGreen
        emailTextField.autocapitalizationType = .none
        emailTextField.textColor = Colors.secondaryDark
        emailTextField.placeholderColor = UIColor.lightGray
        emailTextField.iconType = .image
        emailTextField.iconImage = UIImage(named: "gmail")
        
        
        let passwordTextField = SkyFloatingLabelTextFieldWithIcon()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(passwordTextField)
        passwordTextField.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: 24).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: cardView.rightAnchor, constant: -24).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 24).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.placeholder = "  Password"
        passwordTextField.title = "Password"
        passwordTextField.selectedLineColor = Colors.darkGreen
        passwordTextField.selectedTitleColor = Colors.darkGreen
        passwordTextField.textContentType = .password
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textColor = Colors.secondaryDark
        passwordTextField.placeholderColor = UIColor.lightGray
        passwordTextField.iconType = .image
        passwordTextField.iconImage = UIImage(named: "key")
        
        let storeKeeperLabel = UILabel()
        storeKeeperLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(storeKeeperLabel)
        storeKeeperLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 26).isActive = true
        storeKeeperLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor, constant: 12).isActive = true
        storeKeeperLabel.text = "Are you a store keeper?"
        storeKeeperLabel.textColor = Colors.darkGreen
        
        let isStoreKeeperButton = UIButton()
        isStoreKeeperButton.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(isStoreKeeperButton)
        
        isStoreKeeperButton.rightAnchor.constraint(equalTo: storeKeeperLabel.leftAnchor, constant: -12).isActive = true
        isStoreKeeperButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24).isActive = true
        isStoreKeeperButton.setBackgroundImage(UIImage(named: "selectedCheckBox"), for: .selected)
        isStoreKeeperButton.setBackgroundImage(UIImage(named: "unselectedCheckBox"), for: .normal)
        isStoreKeeperButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        isStoreKeeperButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        isStoreKeeperButton.addTarget(self, action: #selector(isStoreKeeperButtonPressed), for: .touchUpInside)
        
        let signUpButton = UIButton()
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(signUpButton)
        signUpButton.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: 24).isActive = true
        signUpButton.rightAnchor.constraint(equalTo: cardView.rightAnchor, constant: -24).isActive = true
        signUpButton.topAnchor.constraint(equalTo: isStoreKeeperButton.bottomAnchor, constant: 24).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        signUpButton.backgroundColor = Colors.darkGreen
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.cornerRadius = 27.5
        signUpButton.layer.masksToBounds = false
        signUpButton.clipsToBounds = true
        
        
        
        let logoImageView = UIImageView()
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(logoImageView)
        logoImageView.bottomAnchor.constraint(equalTo: cardView.topAnchor , constant: -16).isActive = true
        logoImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 42.5).isActive = true
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.image = UIImage(named: "thel@homeLogoLight")
        
        
        let signInButton = UIButton()
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(signInButton)
        
        signInButton.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        signInButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -48).isActive = true
        signInButton.setTitle("Already have an account? Sign In Instead", for: .normal)
        signInButton.setTitleColor(Colors.secondaryDark, for: .normal)
        signInButton.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
    }
    
    @objc func signInButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func isStoreKeeperButtonPressed(sender: UIButton){
        sender.isSelected = !sender.isSelected
    }

}
