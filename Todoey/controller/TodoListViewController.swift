//
//  ViewController.swift
//  Todoey
//
//  Created by Maurício de Freitas Sayão on 27/05/19.
//  Copyright © 2019 Maurício de Freitas Sayão. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["teste01", "teste02", "teste03"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType ==  UITableViewCell.AccessoryType.checkmark{
            cell?.accessoryType = .none
        } else {
            cell?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
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
                    self.itemArray.append(text)
                    self.tableView.reloadData()
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
}

