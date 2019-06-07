//
//  ViewController.swift
//  Todoey
//
//  Created by Maurício de Freitas Sayão on 27/05/19.
//  Copyright © 2019 Maurício de Freitas Sayão. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    var items: Results<Activity>?
    var selectedCategory: Category? {
        didSet {
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let color = selectedCategory?.color {
            title = selectedCategory?.name
            updateNavBar(with: color)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(with: "7A81F6")
    }
    
    private func updateNavBar(with hexColor: String){
        
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exists!")
        }
        guard let navBarColor = UIColor(hexString: hexColor) else  {
            fatalError("Color does not exists!")
        }
        
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchBar.barTintColor = navBarColor
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let activity = items?[indexPath.row] {
            cell.textLabel?.text = activity.title
            cell.accessoryType = activity.isChecked ? .checkmark : .none
            setColor(in: cell, index: indexPath.row)
        } else {
            cell.textLabel?.text = "No activity added!"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let activity = items?[indexPath.row] {
            do {
                try realm.write {
                    activity.isChecked = !activity.isChecked
                    tableView.deselectRow(at: indexPath, animated: true)
                    self.tableView.reloadData()
                }
            } catch {
                alertControl(message: "Error on update activity!")
            }
            
        }
    }
    
    private func setColor(in cell: UITableViewCell, index: Int) {
        if let category = selectedCategory {
            if let count = items?.count{
                if let color = UIColor(hexString: category.color)?.darken(byPercentage: CGFloat(index) / CGFloat(count)) {
                    cell.backgroundColor = color
                    cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                }
            }
        }
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
                    
                    do {
                        try self.realm.write {
                            let activity = Activity()
                            activity.title = text
                            self.selectedCategory?.activities.append(activity)
                            self.tableView.reloadData()
                        }
                    } catch {
                        self.alertControl(message: "Error in save activity!")
                    }
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
    
    func loadData() {
        items = selectedCategory?.activities.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    override func updateView(at index: Int) {
        if let item = items?[index] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error on delete \(error)")
            }
        }
    }
}

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
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

