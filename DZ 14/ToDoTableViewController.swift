//
//  ToDoTableViewController.swift
//  DZ 14
//
//  Created by Питонейшество on 18/11/2019.
//  Copyright © 2019 Питонейшество. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoTableViewController: UITableViewController {
    
    var realm: Realm!
    var toDoList: Results<ToDoItem> {
        get {
            return realm.objects(ToDoItem.self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        let item = toDoList[indexPath.row]
        cell.textLabel?.text = item.name
        cell.backgroundColor = .clear
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = toDoList[indexPath.row]
        try! self.realm.write {
            item.done = !item.done
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete) {
            let item = toDoList[indexPath.row]
            try! self.realm.write {
                self.realm.delete(item)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        let alertVC = UIAlertController(title: "New Todo", message: "what do you want to do?", preferredStyle: .alert)
        alertVC.addTextField { (UITextField) in
        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil)
        alertVC.addAction(cancelAction)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (UIAlertAction) in
            let todoItemTextField = (alertVC.textFields?.first)! as UITextField
            let newToDoItem = ToDoItem()
            newToDoItem.name = todoItemTextField.text!
            newToDoItem.done = false
            
            try! self.realm.write {
                self.realm.add(newToDoItem)
                self.tableView.insertRows(at: [IndexPath.init(row: self.toDoList.count - 1, section: 0)], with: .automatic)
            }
        }
        alertVC.addAction(addAction)
        present(alertVC, animated: true, completion: nil)
    }

}


