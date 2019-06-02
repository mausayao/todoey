//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Maurício de Freitas Sayão on 02/06/19.
//  Copyright © 2019 Maurício de Freitas Sayão. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories: [Category] = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToActivities", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TodoListViewController
        let indexPath = tableView.indexPathForSelectedRow
        destination.selectedCategory = categories[indexPath!.row]
    }
    
    @IBAction func add(_ sender: UIBarButtonItem) {
        var inputText = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Input a category"
            inputText = textField
        }
        
        let action = UIAlertAction(title: "Save", style: .default) { (action) in
            let category = Category(context: self.context)
            
            if let text = inputText.text {
                if text != "" {
                    category.name = inputText.text!
                    self.categories.append(category)
                    self.save()
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
    
    private func save() {
        do {
            try context.save()
        } catch {
            alertControl(message: "Error in save category.")
        }
        tableView.reloadData()
    }
    
    private func loadData() {
        let data: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categories = try context.fetch(data)
        } catch {
            print("Error in fetch request -> \(error)")
        }
    }
    
}
