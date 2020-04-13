//
//  CartViewController.swift
//  Thela At Home
//
//  Created by Vandit Jain on 13/04/20.
//  Copyright © 2020 jainvandit. All rights reserved.
//

import UIKit
import Kingfisher
import CoreData
import GMStepper

protocol cartViewDismissedDelegate {
    func didChangeCart(didChange: Bool)
}

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    let sectionHeaders = ["Cart", "Wishlist"]
    struct item{
        var item_id:String
        var name:String
        var image_url:String
        var price:Int64
        var quantity:Int64
        init(item: [String:Any], quantity: Int64) {
            item_id = item["item_id"] as? String ?? ""
            name = item["name"] as? String ?? ""
            image_url = item["image_url"] as? String ?? ""
            price = item["price"] as? Int64 ?? 0
            self.quantity = quantity
        }
    }
    var didChange: Bool = false
    var wishlist = [item]()
    var cart = [item]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section==0){
            return cart.count
        }else{
            return wishlist.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemTableViewCell") as? itemTableViewCell else {
            return UITableViewCell()
        }
        if(indexPath.section == 0){
            cell.itemImage.kf.setImage(with: URL(string: self.cart[indexPath.row].image_url))
            cell.nameLabel.text = self.cart[indexPath.row].name
            cell.priceLabel.text = "Rs: \(self.cart[indexPath.row].price)"
            cell.stepper.value = Double(self.cart[indexPath.row].quantity)
            cell.stepper.tag = indexPath.row
            cell.stepper.removeTarget(self, action: #selector(newCartItemAdded), for: .valueChanged)
            cell.stepper.addTarget(self, action: #selector(newCartItemAdded), for: .valueChanged)
        }else{
            cell.itemImage.kf.setImage(with: URL(string: self.wishlist[indexPath.row].image_url))
            cell.nameLabel.text = self.wishlist[indexPath.row].name
            cell.priceLabel.text = "Rs: \(self.wishlist[indexPath.row].price)"
            cell.stepper.value = Double(self.wishlist[indexPath.row].quantity)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    
    var delegate: cartViewDismissedDelegate? = nil

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        getUser()
        // Do any additional setup after loading the view.
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
            let cartItems = user?.value(forKey: "cart") as? [[String:Any]] ?? []
            for item in cartItems {
                self.getItem(item_id: item["item_id"] as? String ?? "", quantity: item["quantity"] as? Int64 ?? 0, isWishlist: false)
            }
            let wishlistItems = user?.value(forKey: "wishlist") as? [[String:Any]] ?? []
            for item in wishlistItems {
                self.getItem(item_id: item["item_id"] as? String ?? "", quantity: item["quantity"] as? Int64 ?? 0, isWishlist: true)
            }
        }catch let error{
            print(error.localizedDescription)
        }
    }
    func getItem(item_id:String, quantity:Int64, isWishlist:Bool){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let predicate = NSPredicate(format: "item_id = %@", item_id)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Item")
        fetchRequest.predicate = predicate
        do{
             let Items = try managedContext.fetch(fetchRequest)
             let item = Items.first
            if(isWishlist){
                self.wishlist.append(CartViewController.item(item: ["item_id": item?.value(forKey: "item_id"), "name":item?.value(forKey: "name"), "image_url": item?.value(forKey: "image_url"), "price": item?.value(forKey: "price")], quantity: quantity))
            }else{
                self.cart.append(CartViewController.item(item: ["item_id": item?.value(forKey: "item_id"), "name":item?.value(forKey: "name"), "image_url": item?.value(forKey: "image_url"), "price": item?.value(forKey: "price")], quantity: quantity))
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }catch let error{
            print(error.localizedDescription)
        }

    }
    
    @objc func newCartItemAdded(_ sender: GMStepper){
            didChange = true
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
                return
            }
           let managedContext = appDelegate.persistentContainer.viewContext
            let quantity = Int64(sender.value)
           let item_id = cart[sender.tag].item_id
           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
           fetchRequest.predicate = NSPredicate(format: "isCurrentUser = %@", NSNumber(value: true))
           do{
                if let first = self.cart.indices.filter({cart[$0].item_id == item_id}).first {
                    DispatchQueue.main.async {
                        self.cart[first].quantity = quantity
                        self.tableView.reloadData()
                    }
                }
               if let fetchResults = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                   if fetchResults.count != 0{
                       let managedObject = fetchResults.first
                       guard var cart = managedObject?.value(forKey: "cart") as? [[String:Any]] else {
                           return
                       }
                       if(quantity == 0){
                           let first = cart.indices.filter({ cart[$0]["item_id"] as? String ?? "" == item_id}).first
                           if let first = first{
                               cart.remove(at: first)
                           }
                       }
                       else if(cart.filter({ $0["item_id"] as? String ?? "" == item_id}).count > 0){
                           let first = cart.indices.filter({ cart[$0]["item_id"] as? String ?? "" == item_id}).first
                           cart[first ?? 0]["quantity"] = quantity
                       }else{
                           cart.append(["item_id": item_id, "quantity": quantity, "priority": 3])
                       }
                       managedObject?.setValue(cart, forKey: "cart")
                       try managedContext.save()
                   }
               }
           }catch let error {
               print(error.localizedDescription)
           }
            
           

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
