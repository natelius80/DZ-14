//
//  ToDo2ViewController.swift
//  DZ 14
//
//  Created by Питонейшество on 19/11/2019.
//  Copyright © 2019 Питонейшество. All rights reserved.
//

import UIKit
import CoreData

class ToDo2ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var itemName: [NSManagedObject] = []
    
    var titleTextField: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Title")
        do {
            itemName = try context.fetch(fetchRequest)
        }
        catch {
            print("Error in loading data")
        }
    }
    
    func titleTextField (textfield: UITextField) {
        titleTextField = textfield
        titleTextField.placeholder = "Item Name"
    }

    @IBAction func addButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add your Item", message: "Add your Item name below", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Save", style: .default, handler: self.save)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField(configurationHandler: titleTextField)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(itemName[indexPath.row])
            itemName.remove(at: indexPath.row)
            
            do {
                try context.save()
            }
            catch {
                print("There was an error in deleting")
            }
            self.tableView.reloadData()
        }
    }
    
    func save (alert: UIAlertAction) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Title", in: context)!
        let theTitle = NSManagedObject(entity: entity, insertInto: context)
        theTitle.setValue(titleTextField.text, forKey: "title")
        do {
            try context.save()
            itemName.append(theTitle) }
        catch {
            print("There was an error in saving")
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let title = itemName[indexPath.row]
        cell.textLabel?.text = title.value(forKey: "title") as? String
        cell.backgroundColor = .clear
        return cell
    }
}
