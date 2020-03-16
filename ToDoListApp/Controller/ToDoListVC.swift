//
//  ToDoListVC.swift
//  ToDoListApp
//
//  Created by Sheldon on 3/14/20.
//  Copyright © 2020 wentao. All rights reserved.
//

import UIKit
import CoreData

class ToDoListVC: UITableViewController {
    
    //MARK: - Properties
    var itemArray = [Item]()
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark : .none
        
        
        return cell
    }
    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done.toggle()
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    //MARK: - HelpFunctions
    @IBAction func addButtonPressed(_ sender: Any) {
        var toDOTextField = UITextField()
        // Show an UI alert
        let alertController = UIAlertController(title: "Add New To-DO", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What wil happend once the user clicks the Add Item buttom
            if let title = toDOTextField.text{
                
                let newItem = Item(context: self.context)
                newItem.title = title
                newItem.done = false
                // Relationship
                newItem.parentCategory = self.selectedCategory
                
                self.itemArray.append(newItem)
                self.saveItems()
            }
        }
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new one"
            toDOTextField = alertTextField
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    func saveItems(){
        do{
            try self.context.save()
        }
        catch{
            print("DEBUG: Failed to encode data \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(withRequest request : NSFetchRequest<Item> = Item.fetchRequest(), withPredicate predicate:NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
            request.predicate = compoundPredicate
        }
        else{
            request.predicate = categoryPredicate
        }
        
        do{
            itemArray = try self.context.fetch(request)
            
        }catch{
            print("DEBUG: Failed to fetch data \(error)")
        }
        self.tableView.reloadData()
    }
}


//MARK: - UISearchBarDelegate

extension ToDoListVC : UISearchBarDelegate{
    // Use query for SQLite
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        
        loadItems(withRequest: request,withPredicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            // Dismiss keyboard.
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }        
        }
    }
}
