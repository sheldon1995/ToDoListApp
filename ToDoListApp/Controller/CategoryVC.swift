//
//  CategoryVC.swift
//  ToDoListApp
//
//  Created by Sheldon on 3/16/20.
//  Copyright © 2020 wentao. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
class CategoryVC: UITableViewController {
    
    //MARK: - Properties
    let realm = try! Realm()
    // Results is an auto-updating container type in Realm returned from object queries.
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added"
        return cell
    }
    
    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desinationVC = segue.destination as! ToDoListVC
        if let indexPath = tableView.indexPathForSelectedRow{
            desinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    //MARK: - Help Funtions
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var toDOTextField = UITextField()
        // Show an UI alert
        let alertController = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            // What wil happend once the user clicks the Add Item buttom
            if let name = toDOTextField.text{
                
                let newCategory = Category()
                newCategory.name = name
                self.saveCategories(category: newCategory)
            }
        }
        
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            toDOTextField = alertTextField
        }
        
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    
    func saveCategories(category:Category){
        do{
            try realm.write{
                realm.add(category)
            }
        }
        catch{
            print("DEBUG: Failed to encode data \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories(){
        categoryArray = realm.objects(Category.self)
        self.tableView.reloadData()
    }
    
}


