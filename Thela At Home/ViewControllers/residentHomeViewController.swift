//
//  residentHomeViewController.swift
//  Thela At Home
//
//  Created by Vandit Jain on 12/04/20.
//  Copyright © 2020 jainvandit. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher
import GMStepper

class residentHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, cartViewDismissedDelegate {
    
    func didChangeCart(didChange: Bool) {
        if(didChange){
            print("Delegate Called")
            getUser()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(societyID == ""){
            self.performSegue(withIdentifier: "showSocietyPageSegue", sender: self)
        }
        appDelegate = (UIApplication.shared.delegate as? AppDelegate)!
        addViews()
        getAllItems()
        getUser()
        print("IN LOADINN G OG RESIDENT: \(self.user_id)")
    }
    
    override func viewWillLayoutSubviews() {
        setUpNavBar()
    }
    
    var societyID:String = ""
    var user_id:String = ""
    
    func addViews(){
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 60
        self.tableView.separatorColor = .clear
        self.tableView.layer.borderColor = UIColor.clear.cgColor
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentItems = items
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            return
        }
        currentItems = items.filter({ item -> Bool in
            item.name.lowercased().contains(searchText.lowercased())
        })
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    var alreadyPresent = [String:Int64]()
    struct item{
        var item_id:String
        var name:String
        var image_url:String
        var price:Int64
        init(item: [String:Any]) {
            item_id = item["item_id"] as? String ?? ""
            name = item["name"] as? String ?? ""
            image_url = item["image_url"] as? String ?? ""
            price = item["price"] as? Int64 ?? 0
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var items = [item]()
    var currentItems = [item]()
    var appDelegate: AppDelegate? = nil

    func setUpNavBar(){
        let width = self.view.frame.width
        let ThelaLogo = UIImage(named: "thel@homeLogoDark")
        let titleImageView = UIImageView(image: ThelaLogo)
        titleImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        titleImageView.contentMode = .scaleAspectFill
        let imageItem = UIBarButtonItem.init(customView: titleImageView)
        navigationItem.leftBarButtonItem = imageItem
        
        let cartLogo = UIImage(named: "cart")
        let cartImageView = UIImageView(image: cartLogo)
        cartImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        cartImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        let cartItem = UIBarButtonItem.init(customView: cartImageView)
        let accountLogo = UIImage(named: "account")
        let accountImageView = UIImageView(image: accountLogo)
        accountImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        accountImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        let accountItem = UIBarButtonItem.init(customView: accountImageView)
        navigationItem.rightBarButtonItems = [accountItem,UIBarButtonItem(),cartItem]
        self.navigationController?.navigationBar.setItems([navigationItem], animated: false)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = .white
        navigationItem.rightBarButtonItems?[0].customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(accountButtonPressed)))
        
        navigationItem.rightBarButtonItems?[2].customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cartButtonPressed)))
        
//        let dividerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 1))
//        dividerView.backgroundColor = .lightGray
//        self.view.addSubview(dividerView)
        
    }
    @objc func cartButtonPressed(){
        performSegue(withIdentifier: "showCartSegue", sender: self)
    }
    @objc func accountButtonPressed(){
        performSegue(withIdentifier: "showAccountSegue", sender: self)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "itemTableViewCell") as? itemTableViewCell else {
            return UITableViewCell()
        }
        cell.nameLabel.text = currentItems[indexPath.row].name.capitalized
        cell.itemImage.kf.setImage(with: URL(string: currentItems[indexPath.row].image_url))
        cell.priceLabel.text = "Rs: \(currentItems[indexPath.row].price)"
        cell.stepper.tag = indexPath.row
        cell.stepper.addTarget(self, action: #selector(newItemAdded), for: .valueChanged)
        if(alreadyPresent[currentItems[indexPath.row].item_id] != nil){
            print("I'm here")
            let value = Int(alreadyPresent[currentItems[indexPath.row].item_id]!)
            cell.stepper.value = Double( value)
        }
        return cell
        
    }
    
    @objc func newItemAdded(_ sender: GMStepper){
        
        let managedContext = appDelegate!.persistentContainer.viewContext
        let item_id = currentItems[sender.tag].item_id
        let quantity = Int64(sender.value)
        
        alreadyPresent[item_id] = quantity
        print("Here I Am Quantity: \(quantity)")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "isCurrentUser = %@", NSNumber(value: true))
        do{
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
    
    func getAllItems(){
        getDataFunction(url: "\(Constants.dev.rootURL)items/getAll", requestMethod: "GET") { (data) in
            self.saveItems(data: data)
        }
    }
    
    func saveItems(data: Data){
        let managedContext = appDelegate!.persistentContainer.viewContext
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]{
                guard let items = json["data"] as? [[String:Any]] else {
                    return
                }
                for singleItem in items {
                    self.items.append(residentHomeViewController.item(item: singleItem))
                    let itemEntity = NSEntityDescription.entity(forEntityName: "Item", in: managedContext)!
                    if(doesValueExistInCoreData(entityName: "Item", value: singleItem["item_id"] as? String ?? "", key: "item_id", managedContext: managedContext)){
                        print("Item  \(singleItem["name"]) EXISTS")
                        continue
                    }
                    let item = NSManagedObject(entity: itemEntity, insertInto: managedContext)
                    item.setValue(singleItem["image_url"] as? String ?? "", forKey: "image_url")
                    item.setValue(singleItem["item_id"] as? String ?? "", forKey: "item_id")
                    item.setValue(singleItem["name"] as? String ?? "", forKey: "name")
                    item.setValue(singleItem["price"] as? Int64 ?? 0, forKey: "price")
                }
                managedContext.performAndWait {
                    do {
                        try managedContext.save()
                        print("Number of items = \(self.getRecordsCount(entityName: "Item"))")
                        print("Number of items in VC = \(self.items.count)")
                    }catch let error{
                        print("SAVE ITEMS \(error.localizedDescription)")
                    }
                }
                self.currentItems = self.items
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }catch let error{
            print("ERRORORORORO \(error.localizedDescription)")
        }
    }
    
    func getDataFunction(url: String, requestMethod: String, params: [String:Any] = [:], completionHandler: @escaping (Data) -> ()) {
        guard let url = URL(string: url) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = requestMethod
        request.addValue(Constants.headers.accept, forHTTPHeaderField: "Accept")
        request.addValue(Constants.headers.contentType, forHTTPHeaderField: "Content-Type")
        if(params.count != 0){
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            }catch let error {
                print(error.localizedDescription)
            }
        }
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in

            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }

            guard let data = data else {
                print("No Data Found?")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]{
                    let status = json["status"] as? Int ?? 400
                    if(status == 400){
                        print("Error: \(json["message"] as? String ?? "")")
                    }else{
                        completionHandler(data)
                    }
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getRecordsCount(entityName: String) -> Int{
      let managedContext = appDelegate!.persistentContainer.viewContext
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let count = try managedContext.count(for: fetchRequest)
            return count
        } catch {
            print(error.localizedDescription)
        }
      return 0
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
                alreadyPresent[item["item_id"] as? String ?? "" ] = item["quantity"] as? Int64 ?? 0
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSocietyPageSegue" {
            guard let destinationVC = segue.destination as? NoSocietyViewController else {
                return
            }
            print("IN SEGUE: \(self.user_id)")
            destinationVC.user_id = self.user_id
        }
    }
}
