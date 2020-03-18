//
//  ToDoListVC.swift
//  ToDoListApp
//
//  Created by Sheldon on 3/14/20.
//  Copyright © 2020 wentao. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListVC: SwipeTableVC {
    
    //MARK: - Properties
    let realm = try! Realm()
    var todoItems : Results<Item>?
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex =  selectedCategory?.color{
            title = selectedCategory!.name
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller doesn't exist")}
            
            if let navBarColor = UIColor(hexString: colorHex){                
                navBar.standardAppearance.backgroundColor = navBarColor
                navBar.compactAppearance?.backgroundColor = navBarColor
                navBar.scrollEdgeAppearance?.backgroundColor = navBarColor
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:ContrastColorOf(navBarColor, returnFlat: true)]
                searchBar.barTintColor = navBarColor
                
                searchBar.searchTextField.backgroundColor = .white
            }
        }
    }
    
    //MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat( indexPath.row) / CGFloat(todoItems!.count))
            {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            cell.accessoryType = item.done == true ? .checkmark : .none
        }
        else{
            cell.textLabel?.text = "No Items Added"
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
    
    override func updateModel(at indexPath: IndexPath) {
        if let items = self.todoItems{
            do{
                try self.realm.write{
                    self.realm.delete(items[indexPath.row])
                }
            }catch{
                print("DEUBG: Failed to delete \(error)")
            }
            
        }
        
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
