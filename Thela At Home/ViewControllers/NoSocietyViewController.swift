//
//  NoSocietyViewController.swift
//  Thela At Home
//
//  Created by Vandit Jain on 13/04/20.
//  Copyright © 2020 jainvandit. All rights reserved.
//

import UIKit
import CoreData

class NoSocietyViewController: UIViewController {

    @IBOutlet weak var inviteCodeTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        print("USER ID: \(user_id)")
        errorAlertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (UIAlertAction) in
           self.errorAlertController.dismiss(animated: true, completion: nil)
       }))
        if(self.user_id == ""){
            getUser()
        }
    }
    
    let errorAlertController = UIAlertController(title: "Error", message: "", preferredStyle: .alert)
    var user_id = ""
    var appDelegate:AppDelegate? = nil
    
    @IBAction func goButtonPressed(_ sender: Any) {
        let inviteCode = inviteCodeTF.text
        guard let url = URL(string: "\(Constants.dev.rootURL)societies/getSocietyByInvitationCode") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let data:[String:Any] = [
            "invitationCode": inviteCode
        ]
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            
        }catch let error {
            print("ERROR IN GET \(error.localizedDescription)")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                DispatchQueue.main.async {
                    self.errorAlertController.message = "Some Error Occured"
                    self.present(self.errorAlertController, animated: true)
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorAlertController.message = "Some Error Occured"
                    self.present(self.errorAlertController, animated: true)
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]{
                    print(json)
                    let status = json["status"] as? Int ?? 400
                    if(status == 400){
                        DispatchQueue.main.async {
                            self.errorAlertController.message = json["message"] as? String ?? "Some Error Occured"
                            self.present(self.errorAlertController, animated: true)
                        }
                    }else{
                        let data = json["data"] as! [String:Any]
                        print(data)
                        self.updateUser(society_id: data["society_id"] as? String ?? "")
                    }
                }
            }
            catch let error {
                DispatchQueue.main.async {
                    self.errorAlertController.message = "Some Error Occured"
                    self.present(self.errorAlertController, animated: true)
                }
                print("ERROR IN GET \(error.localizedDescription)")
            }
        })
        task.resume()
    }
    
    func updateUser(society_id:String){
        guard let url = URL(string: "\(Constants.dev.rootURL)users/addToSociety") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let data:[String:Any] = [
            "user_id": user_id,
            "society_id": society_id
        ]
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            
        }catch let error {
            print("ERROR IN POST \(error.localizedDescription)")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                DispatchQueue.main.async {
                    self.errorAlertController.message = "Some Error Occured"
                    self.present(self.errorAlertController, animated: true)
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
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
                            self.errorAlertController.message = json["message"] as? String ?? "Some Error Occured"
                            self.present(self.errorAlertController, animated: true)
                        }
                    }else{
                        self.updateCoreDataUserValue(society_id: society_id)
                        self.getSociety(society_id: society_id)
                    }
                }
            }
            catch let error {
                DispatchQueue.main.async {
                    self.errorAlertController.message = "Some Error Occured"
                    self.present(self.errorAlertController, animated: true)
                }
                print("ERROR IN POST \(error.localizedDescription)")
            }
        })
        task.resume()
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getSociety(society_id:String){
        guard let url = URL(string: "\(Constants.dev.rootURL)societies/getSingle") else {
           return
       }
       var request = URLRequest(url: url)
       request.httpMethod = "POST"
       let data:[String:Any] = [
           "society_id": society_id
       ]
       do{
           request.httpBody = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
           
       }catch let error {
           print("ERROR IN POST \(error.localizedDescription)")
       }
       request.addValue("application/json", forHTTPHeaderField: "Content-Type")
       request.addValue("application/json", forHTTPHeaderField: "Accept")
       let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

           guard error == nil else {
               DispatchQueue.main.async {
                   self.errorAlertController.message = "Some Error Occured"
                   self.present(self.errorAlertController, animated: true)
               }
               return
           }

           guard let data = data else {
               DispatchQueue.main.async {
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
                           self.errorAlertController.message = json["message"] as? String ?? "Some Error Occured"
                           self.present(self.errorAlertController, animated: true)
                       }
                   }else{
                       self.saveSociety(data: data)
                       DispatchQueue.main.async {
                           self.dismiss(animated: true, completion: nil)
                       }
                   }
               }
           }
           catch let error {
               DispatchQueue.main.async {
                   self.errorAlertController.message = "Some Error Occured"
                   self.present(self.errorAlertController, animated: true)
               }
               print("ERROR IN POST \(error.localizedDescription)")
           }
       })
       task.resume()
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
            self.user_id = user?.value(forKey: "user_id") as? String ?? ""
        }catch let error{
            print(error.localizedDescription)
        }
    }
    func updateCoreDataUserValue(society_id: String){
       let managedContext = appDelegate!.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        do{
            let Users = try managedContext.fetch(fetchRequest)
            let user = Users.first
            user?.setValue(society_id, forKey: "society_id")
            try managedContext.save()
       }catch let error{
           print(error.localizedDescription)
       }
    }
    func saveSociety(data: Data){
        let managedContext = appDelegate!.persistentContainer.viewContext
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]{
                guard let Society = json["data"] as? [String:Any] else {
                    return
                }
                let societyEntity = NSEntityDescription.entity(forEntityName: "Society", in: managedContext)!
                if(doesValueExistInCoreData(entityName: "Society", value: Society["society_id"] as? String ?? "", key: "society_id", managedContext: managedContext)){
                    print("Society  \(Society["name"]) EXISTS")
                    return
                }
                let societyObject = NSManagedObject(entity: societyEntity, insertInto: managedContext)
                societyObject.setValue(Society["society_id"] as? String ?? "", forKey: "society_id")
                societyObject.setValue(Society["location"] as? [String:Any] ?? [:], forKey: "location")
                societyObject.setValue(Society["name"] as? String ?? "", forKey: "name")
                societyObject.setValue(Society["users"] as? [String] ?? [], forKey: "users")
                societyObject.setValue(Society["invitationCode"] as? String ?? "", forKey: "invitationCode")
                societyObject.setValue(true, forKey: "isCurrentSociety")
                managedContext.performAndWait {
                    do {
                        try managedContext.save()
                    }catch let error{
                        print("SAVE Society \(error.localizedDescription)")
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
}
