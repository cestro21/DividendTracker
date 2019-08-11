//
//  CategoryTableViewController.swift
//  DividendTracker
//
//  Created by Justin Cestro on 8/11/19.
//  Copyright © 2019 moji applications. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        // Ternary Operator ==>
        // Value = condition ? valueIfTrue : valueIfFalse
        
//        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PortfolioViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selcectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
        
    }
        
        func loadCategories() {
            
            let request: NSFetchRequest<Category> = Category.fetchRequest()
      
            do {
                categoryArray = try context.fetch(request)
            } catch {
                print("Error fetching data from context, \(error)")
            }

            tableView.reloadData()

        }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
          
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
        alertTextField.placeholder = "Add new category"
        textField = alertTextField
    
        }
    
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    

}
