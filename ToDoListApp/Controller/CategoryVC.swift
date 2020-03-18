//
//  CategoryVC.swift
//  ToDoListApp
//
//  Created by Sheldon on 3/16/20.
//  Copyright © 2020 wentao. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryVC: SwipeTableVC {
    
    //MARK: - Properties
    let realm = try! Realm()
    // Results is an auto-updating container type in Realm returned from object queries.
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller doesn't exist")}
        navBar.standardAppearance.backgroundColor = .systemPink
        navBar.compactAppearance?.backgroundColor = .systemPink
        navBar.scrollEdgeAppearance?.backgroundColor = .systemPink
    
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let hexValue = categoryArray?[indexPath.row].color ?? UIColor.randomFlat().hexValue()
        guard let categoryColor = UIColor(hexString: hexValue) else{fatalError()}
        cell.backgroundColor = categoryColor
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added"
        cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
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
                newCategory.color = UIColor.randomFlat().hexValue()
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
    
    //MARK: deleteDateFromSwipe()
    override func updateModel(at indexPath: IndexPath) {
        if let category = self.categoryArray{
            do{
                try self.realm.write{
                    self.realm.delete(category[indexPath.row])
                }
            }catch{
                print("DEUBG: Failed to delete \(error)")
            }
            
        }
    }
    
}


