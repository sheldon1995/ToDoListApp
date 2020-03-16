//
//  CategoryVC.swift
//  ToDoListApp
//
//  Created by Sheldon on 3/16/20.
//  Copyright © 2020 wentao. All rights reserved.
//

import UIKit
import CoreData

class CategoryVC: UITableViewController {
    
    //MARK: - Properties
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    
    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desinationVC = segue.destination as! ToDoListVC
        if let indexPath = tableView.indexPathForSelectedRow{
            desinationVC.selectedCategory = categoryArray[indexPath.row]
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
                
                let newCategory = Category(context: self.context)
                newCategory.name = name
                
                self.categoryArray.append(newCategory)
                self.saveCategories()
            }
        }
        
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            toDOTextField = alertTextField
        }
        
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    
    func saveCategories(){
        do{
            try self.context.save()
        }
        catch{
            print("DEBUG: Failed to encode data \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories(withRequest request : NSFetchRequest<Category> = Category.fetchRequest()){
        
        do{
            categoryArray = try self.context.fetch(request)
            
        }catch{
            print("DEBUG: Failed to fetch data \(error)")
        }
        self.tableView.reloadData()
    }
    
}


