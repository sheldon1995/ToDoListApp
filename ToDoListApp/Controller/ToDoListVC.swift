//
//  ToDoListVC.swift
//  ToDoListApp
//
//  Created by Sheldon on 3/14/20.
//  Copyright © 2020 wentao. All rights reserved.
//

import UIKit

class ToDoListVC: UITableViewController {
    
    //MARK: - Properties
    var itemArray = ["Buy coffee","Go to Walmart","Pick up GG"]
    
    
    
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
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselects a given row identified by index path
        tableView.deselectRow(at: indexPath, animated: true)
        // The cell we select for will have an accsssory type .checkmark or none.
        let accessType = tableView.cellForRow(at: indexPath)?.accessoryType
        if accessType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
    }
    //MARK: - HelpFunctions
    @IBAction func addButtonPressed(_ sender: Any) {
        var toDOTextField = UITextField()
        // Show an UI alert
        let alertController = UIAlertController(title: "Add New To-DO", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What wil happend once the user clicks the Add Item buttom
            if let title = toDOTextField.text{
                self.itemArray.append(title)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
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
    
}
