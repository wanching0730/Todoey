//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Wan Ching on 21/04/2018.
//  Copyright © 2018 Wan Ching. All rights reserved.
//

import UIKit
import RealmSwift
//import CoreData

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>? // data type that return from Realm query (auto update container)
    
    //var categories = [Category]()
    
    // context for CoreData
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.rowHeight = 80.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Nil Coalescing Operator
        // if categories is not nil return count else return 1
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No category added yet"
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController

        // indexPath might be null, so perform optional binding
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message:"", preferredStyle: .alert)
        
        // Add data using CoreData
//        let action = UIAlertAction(title: "Add", style: .default) { (action) in
//
//            let newCategory = Category(context: self.context)
//            newCategory.name = textField.text!
//
//            self.categories.append(newCategory)
//
//            self.saveCategories()
//        }
        
        // Add data using Realm
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            
            //self.categories.append(newCategory)
            
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            textField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
//    load data with CoreData
//    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
//
//        do{
//            categories = try context.fetch(request)
//        } catch {
//            print("Error in fetching data from context \(error)")
//        }
//
//        tableView.reloadData()
//    }
    
    // load data with Realm
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    
    
//    // save data using CoreData
//    func saveCategories() {
//
//        do{
//            try context.save()
//        } catch {
//            print("Error in saving context \(error)")
//        }
//
//        self.tableView.reloadData()
//    }
    
    // save data using Realm
    func save (category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error in saving data to Realm \(error)")
        }
        
        self.tableView.reloadData()
    }
}
