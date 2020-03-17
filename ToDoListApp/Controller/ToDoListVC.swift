//
//  ToDoListVC.swift
//  ToDoListApp
//
//  Created by Sheldon on 3/14/20.
//  Copyright © 2020 wentao. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListVC: UITableViewController {
    
    //MARK: - Properties
    let realm = try! Realm()
    var todoItems : Results<Item>?
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done == true ? .checkmark : .none
        }
        
        
        return cell
    }
    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item =  todoItems?[indexPath.row]
        {
            do{
                try realm.write{
                    item.done.toggle()
                }
            }
            catch{
                print("DEBUG: Failed at didSelectRowAt \(error)")
            }
        }
        tableView.reloadData()
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
                if let currentCategory = self.selectedCategory{
                    do{
                        try self.realm.write{
                            let newItem = Item()
                            newItem.title = title
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                            self.tableView.reloadData()
                        }
                    }
                    catch{
                       print("DEBUG: Failed to add new items \(error)")
                    }
                }
               
            }
        }
        
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new one"
            toDOTextField = alertTextField
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title",ascending: true)
        self.tableView.reloadData()
    }
}


//MARK: - UISearchBarDelegate

extension ToDoListVC : UISearchBarDelegate{
    // Use query for SQLite
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated",ascending: true)
        tableView.reloadData()
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
