//
//  SignInViewController.swift
//  Thela At Home
//
//  Created by Vandit Jain on 11/04/20.
//  Copyright © 2020 jainvandit. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import NVActivityIndicatorView
import TransitionButton
import CoreData

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
    }
    
    let emailTextField = SkyFloatingLabelTextFieldWithIcon()
    let passwordTextField = SkyFloatingLabelTextFieldWithIcon()
    let errorAlertController = UIAlertController(title: "Error", message: "", preferredStyle: .alert)
    var societyID = ""
    var user_id = ""
    var appDelegate:AppDelegate? = nil

    func createViews(){
        let backgroundImageView = UIImageView()
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backgroundImageView)
        backgroundImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        backgroundImageView.heightAnchor.constraint(equalToConstant: self.view.frame.height * 0.8).isActive = true
        backgroundImageView.image = UIImage(named: "signInBackground")
        backgroundImageView.contentMode = .scaleAspectFill
        
        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cardView)
        cardView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        cardView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        cardView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        cardView.heightAnchor.constraint(equalToConstant: 375).isActive = true
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 20
        cardView.layer.masksToBounds = false
        cardView.clipsToBounds = true
        
        let logInLabel = UILabel()
        logInLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(logInLabel)
        logInLabel.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: 24).isActive = true
        logInLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24).isActive = true
        logInLabel.text = "Sign In"
        logInLabel.textColor = Colors.secondaryDark
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(emailTextField)
        emailTextField.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: 24).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: cardView.rightAnchor, constant: -24).isActive = true
        emailTextField.topAnchor.constraint(equalTo: logInLabel.bottomAnchor, constant: 24).isActive = true
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
        
        let signInButton = TransitionButton()
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(signInButton)
        signInButton.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: 24).isActive = true
        signInButton.rightAnchor.constraint(equalTo: cardView.rightAnchor, constant: -24).isActive = true
        signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        signInButton.backgroundColor = Colors.darkGreen
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.layer.cornerRadius = 27.5
        signInButton.layer.masksToBounds = false
        signInButton.clipsToBounds = true
        signInButton.spinnerColor = .white
        signInButton.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
        
        
        let logoImageView = UIImageView()
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(logoImageView)
        logoImageView.bottomAnchor.constraint(equalTo: cardView.topAnchor , constant: -16).isActive = true
        logoImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 42.5).isActive = true
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.image = UIImage(named: "thel@homeLogoLight")
        
        
        
        let signUpButton = UIButton()
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(signUpButton)
        
        signUpButton.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        signUpButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -48).isActive = true
        signUpButton.setTitle("Don't have an account? Sign Up Instead", for: .normal)
        signUpButton.setTitleColor(Colors.secondaryDark, for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        
        errorAlertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (UIAlertAction) in
            self.errorAlertController.dismiss(animated: true, completion: nil)
        }))

    }
    
    @objc func signUpButtonPressed(){
        self.performSegue(withIdentifier: "signUpSegue", sender: self)
    }
    
    @objc func signInButtonPressed(_ button: TransitionButton){
        button.startAnimation()
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        backgroundQueue.async(execute: {
            guard let url = URL(string: "\(Constants.dev.rootURL)users/login") else {
                DispatchQueue.main.async {
                    button.stopAnimation(animationStyle: .shake,  completion: {
                        button.cornerRadius = 27.5
                    })
                }
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let data:[String:Any] = [
                "email": email,
                "password": password
            ]
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            }
            catch let error {
                DispatchQueue.main.async {
                    button.stopAnimation(animationStyle: .shake,  completion: {
                        button.cornerRadius = 27.5
                    })
                    self.errorAlertController.message = "Some Error Occured"
                    self.present(self.errorAlertController, animated: true)
                }
                print(error.localizedDescription)
            }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

                guard error == nil else {
                    DispatchQueue.main.async {
                        button.stopAnimation(animationStyle: .shake,  completion: {
                            button.cornerRadius = 27.5
                        })
                        self.errorAlertController.message = "Some Error Occured"
                        self.present(self.errorAlertController, animated: true)
                    }
                    return
                }

                guard let data = data else {
                    DispatchQueue.main.async {
                        button.stopAnimation(animationStyle: .shake,  completion: {
                            button.cornerRadius = 27.5
                        })
                        self.errorAlertController.message = "Some Error Occured"
                        self.present(self.errorAlertController, animated: true)
                    }
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]{
                        print(json)
                        let status = json["status"] as? Int ?? 400
                        if(status == 400){
                            DispatchQueue.main.async {
                                button.stopAnimation(animationStyle: .shake,  completion: {
                                    button.cornerRadius = 27.5
                                })
                                self.errorAlertController.message = json["message"] as? String ?? "Some Error Occured"
                                self.present(self.errorAlertController, animated: true)
                            }
                        }else{
                            self.saveUser(data: data)
                            DispatchQueue.main.async {
                                button.stopAnimation(animationStyle: .expand, completion: {
                                    self.performSegue(withIdentifier: "signedInSegue", sender: self)
                                })
                            }
                        }
                    }
                }
                catch let error {
                    DispatchQueue.main.async {
                        button.stopAnimation(animationStyle: .shake,  completion: {
                            button.cornerRadius = 27.5
                        })
                        self.errorAlertController.message = "Some Error Occured"
                        self.present(self.errorAlertController, animated: true)
                    }
                    print(error.localizedDescription)
                }
            })
            task.resume()
        })
        //signIn()
    }
    
    func saveUser(data: Data){
        let managedContext = appDelegate!.persistentContainer.viewContext
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]{
                guard let User = json["data"] as? [String:Any] else {
                    return
                }
                self.societyID = User["society_id"] as? String ?? ""
                self.user_id = User["user_id"] as? String ?? ""
                print("SAVE LOCATIONN: \(self.user_id)")
                let userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
                if(doesValueExistInCoreData(entityName: "User", value: User["user_id"] as? String ?? "", key: "user_id", managedContext: managedContext)){
                    print("User  \(User["name"]) EXISTS")
                    return
                }
                let userObject = NSManagedObject(entity: userEntity, insertInto: managedContext)
                userObject.setValue(User["user_id"] as? String ?? "", forKey: "user_id")
                userObject.setValue(User["society_id"] as? String ?? "", forKey: "society_id")
                userObject.setValue(User["name"] as? String ?? "", forKey: "name")
                userObject.setValue(User["email"] as? String ?? "", forKey: "email")
                userObject.setValue(true, forKey: "isCurrentUser")
                userObject.setValue(User["cart"] as? [[String:Any]], forKey: "cart")
                userObject.setValue(User["wishlist"] as? [[String:Any]], forKey: "wishlist")
                managedContext.performAndWait {
                    do {
                        try managedContext.save()
                    }catch let error{
                        print("SAVE User \(error.localizedDescription)")
                    }
                }
            }
        }catch let error{
            print("ERRORORORORO \(error.localizedDescription)")
        }
    }
    
    func doesValueExistInCoreData(entityName:String, value:String,key:String , managedContext: NSManagedObjectContext) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "\(key) == %@", value)
        fetchRequest.fetchLimit = 1
        do{
            let count = try managedContext.count(for: fetchRequest)
            if(count > 0){
                return true
            }
        }catch let error {
            print(error.localizedDescription)
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? residentHomeViewController else{
            return
        }
        destinationVC.societyID = societyID
        destinationVC.user_id = user_id
    }
}
