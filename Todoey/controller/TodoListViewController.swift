//
//  ViewController.swift
//  Todoey
//
//  Created by Maurício de Freitas Sayão on 27/05/19.
//  Copyright © 2019 Maurício de Freitas Sayão. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray: [Activity] = [Activity]()
    var selectedCategory: Category? {
        didSet {
            loadData()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let activity = itemArray[indexPath.row]
        cell.textLabel?.text = activity.title
        cell.accessoryType = activity.isChecked ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let activity = itemArray[indexPath.row]
        activity.isChecked = !activity.isChecked
        
        tableView.deselectRow(at: indexPath, animated: true)
        save()
    }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Item description"
            alertTextField = textField
        }
        
        let okAction = UIAlertAction(title: "Add", style: .default) { (action) in
            if let text = alertTextField.text {
                if text != "" {
                    let activity = Activity(context: self.context)
                    activity.isChecked = false
                    activity.title = text
                    activity.refCategory = self.selectedCategory
                    self.itemArray.append(activity)
                    self.save()
                } else {
                    self.alertControl(message: "Field can't be empty")
                }
            }
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func alertControl(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            print("error \(error.localizedDescription)")
        }
        self.tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<Activity> = Activity.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categotyPredicate = NSPredicate(format: "refCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let itemsPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categotyPredicate, itemsPredicate])
        } else {
            request.predicate = categotyPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error on fetch request \(error)")
        }
        tableView.reloadData()
    }
}

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Activity> = Activity.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadData(with: request, predicate: predicate)
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

