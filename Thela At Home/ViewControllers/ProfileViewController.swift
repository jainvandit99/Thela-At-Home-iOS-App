//
//  ProfileViewController.swift
//  Thela At Home
//
//  Created by Vandit Jain on 13/04/20.
//  Copyright © 2020 jainvandit. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileCard: UIView!
    @IBOutlet weak var societyCard: UIView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileEmailLabel: UILabel!
    @IBOutlet weak var societyNameLabel: UILabel!
    @IBOutlet weak var societyInvitationCodeLabel: UILabel!
    var userName: String = ""
    var userEmail: String = ""
    var societyName: String = ""
    var invitationCode: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        getUser()
        getSociety()    
        // Do any additional setup after loading the view.
    }
    
    func setUpViews(){
        self.profileCard.layer.cornerRadius = 25
        self.profileCard.layer.masksToBounds = false
        self.profileCard.clipsToBounds = true
        
        self.societyCard.layer.cornerRadius = 25
        self.societyCard.layer.masksToBounds = false
        self.societyCard.clipsToBounds = true
    }
    func getUser(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
         let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
         do{
             let Users = try managedContext.fetch(fetchRequest)
             let user = Users.first
            self.userName = user?.value(forKey: "name") as? String ?? ""
            self.userEmail = user?.value(forKey: "email") as? String ?? ""
            DispatchQueue.main.async {
                self.setProfileCard()
            }
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    func getSociety(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
         let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Society")
         do{
             let Societies = try managedContext.fetch(fetchRequest)
             let society = Societies.first
            self.societyName = society?.value(forKey: "name") as? String ?? ""
            self.invitationCode = society?.value(forKey: "invitationCode") as? String ?? ""
            DispatchQueue.main.async {
                self.setSocietyCard()
            }
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    func setProfileCard(){
        profileNameLabel.text = "Name: \(userName)"
        profileEmailLabel.text = "Email: \(userEmail)"
    }
    func setSocietyCard(){
        societyNameLabel.text = "Name: \(societyName)"
        societyInvitationCodeLabel.text = "Invitation Code: \(invitationCode)"
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
