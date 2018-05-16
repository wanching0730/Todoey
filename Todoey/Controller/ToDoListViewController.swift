//
//  ViewController.swift
//  Todoey
//
//  Created by Wan Ching on 16/04/2018.
//  Copyright © 2018 Wan Ching. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {

    let realm = try!Realm()
    var toDoItem: Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // call loadData() when selectedCategory has a value
    var selectedCategory: Category? {
        didSet{
            loadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
    }
    
    // this method is called right before the app is showed up, right after navigation bar added to the app
    override func viewWillAppear(_ animated: Bool) {
        
        // already ensure selectedCategory is not nil through optional binding, so can force unwrap it
        title = selectedCategory?.name
        
        // guarantee that this optional binding won't fail, so use guard let
        guard let colourHex = selectedCategory?.colour else {fatalError()}
        
        updateNavBar(withHexcode: colourHex)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexcode: "1D9BF6")
    }
    
    // MARK: - Navbar setup methods
    
    func updateNavBar(withHexcode colorHexcode: String) {
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation bar does not exist")}
        
        // parameter of ContrastColorOf() only accept normal variable, and not Optional variable
        guard let navbarColor = UIColor(hexString: colorHexcode) else {fatalError()}
        
        // navbar background colour
        navBar.barTintColor = navbarColor
        // navbar text colour
        navBar.tintColor = ContrastColorOf(navbarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navbarColor, returnFlat: true)]
        
        searchBar.barTintColor = navbarColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            // if item.done == true, .checkmark is used, else .none is used
            cell.accessoryType = item.done ? .checkmark :  .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItem?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItem?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error in updating done status \(error)")
            }
        }
        
        // Call cellForRowAt method
        tableView.reloadData()

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

        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }
    
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


