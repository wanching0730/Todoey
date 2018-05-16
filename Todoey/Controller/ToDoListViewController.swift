//
//  ViewController.swift
//  Todoey
//
//  Created by Wan Ching on 16/04/2018.
//  Copyright © 2018 Wan Ching. All rights reserved.
//

// Core data: framework to manage model layer object in iOS apps in CRUD our data.
import UIKit
import RealmSwift
import ChameleonFramework
//import CoreData

class ToDoListViewController: SwipeTableViewController {

    let realm = try!Realm()
    var toDoItem: Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    //var itemArray = [Item]()

    // call loadData() when selectedCategory has a value
    var selectedCategory: Category? {
        didSet{
            loadData()
        }
    }

//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // inside UserDefaults class, there is a singleton static object named "standard", everytime pointing to the same static object, so we always editing the same plist
    // defaults can only store data with certain datatype
    // let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        //print(dataFilePath)
    }
    
    // this method called right before the app is showed up, right after navigation bar added to the app
    override func viewWillAppear(_ animated: Bool) {
        if let colourHex = selectedCategory?.colour {
            
            // already ensure selectedCategory is not nil through optional binding, so can force unwrap it
            title = selectedCategory!.name
            
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation bar does not exist")}
            
            navBar.barTintColor = UIColor(hexString: colourHex)
            
            searchBar.barTintColor = UIColor(hexString: colourHex)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let item = toDoItem?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            // use optional chaining to ensure the value is not nil
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItem!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            // Ternary operator
            cell.accessoryType = item.done ? .checkmark :  .none
        } else {
            cell.textLabel?.text = "No items added"
        }

//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItem?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItem?[indexPath.row] {
            do {
                try realm.write {
                    //realm.delete(item)
                    item.done = !item.done
                }
            } catch {
                print("Error in updating done status \(error)")
            }
        }
        
        // Call cellForRowAt method
        tableView.reloadData()

        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done

//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)

        //saveItems()

        tableView.deselectRow(at: indexPath, animated: true)
    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // Add data using Realm
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error in saving data to Realm \(error)")
                }
            }
            
            self.tableView.reloadData()

            // Add data using CoreData
//            let newItem = Item(context: self.context)
//            newItem.title = textField.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//            self.itemArray.append(newItem)
//
//            self.saveItems()

        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }

//    func saveItems() {
////        let encoder = PropertyListEncoder()
//
//        do {
//            // Save data to PList
////            let data = try encoder.encode(itemArray)
////            try data.write(to: dataFilePath!)
//
//            // Save data to CoreData
//            // View backend Sqlite db in /Users/wanching/Library/Developer/CoreSimulator/Devices/FF0EC51A-BF6F-40E5-AC5F-9C00B4BA5F42/data/Containers/Data/Application/0EA25AEF-4083-4F4D-B876-A0DE25CB469C/Library/Application Support/DataModel.sqlite
//            // Use Datum-SQLite Apps
//            try context.save()
//        } catch {
//            print("Error in saving context \(error)")
//        }
//
//        self.tableView.reloadData()
//
//        // self.defaults.set(self.itemArray, forKey: "ToDoListArray")
//    }


    // Load data from CoreData
//    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error in fetching data from context \(error)")
//        }
//
//        tableView.reloadData()


//        // load data from custom data file path
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//                itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("Error in decoding item array, \(error)")
//            }
//        }
//
//        // load data from user default
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = items
//        }
//    }
    
    // Load data from Realm
    func loadData() {
        toDoItem = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = toDoItem?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
            
            
        }
    }

}

//MARK: - SearchBar method

extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItem = toDoItem?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()

//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadData(with: request, predicate: searchPredicate)

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            loadData()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


