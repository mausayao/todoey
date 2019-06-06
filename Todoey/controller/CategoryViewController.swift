//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Maurício de Freitas Sayão on 02/06/19.
//  Copyright © 2019 Maurício de Freitas Sayão. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    var categories:  Results<Category>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let categorie = categories?[indexPath.row] {
            cell.textLabel?.text = categorie.name
            cell.backgroundColor = UIColor(hexString: categorie.color)
        } else {
            cell.textLabel?.text = "No category added!"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToActivities", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TodoListViewController
        let indexPath = tableView.indexPathForSelectedRow
        destination.selectedCategory = categories?[indexPath!.row]
    }
    
    @IBAction func add(_ sender: UIBarButtonItem) {
        var inputText = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Input a category"
            inputText = textField
        }
        
        let action = UIAlertAction(title: "Save", style: .default) { (action) in
            
            if let text = inputText.text {
                if text != "" {
                    let category = Category()
                    category.name = text
                    category.color = RandomFlatColor().hexValue()
                    self.save(category)
                } else {
                    self.alertControl(message: "Field can't be empty")
                }
            }
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func alertControl(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func save(_ category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            alertControl(message: "Error in save category.")
        }
        tableView.reloadData()
    }
    
    private func loadData() {
        categories = realm.objects(Category.self)
    }
    
    override func updateView(at index: Int) {
        if let rowToDelete = self.categories?[index] {
            do {
                try self.realm.write {
                    self.realm.delete(rowToDelete)
                }
            } catch {
                print("Error on delete \(error)")
            }
        }
    }
    
}
