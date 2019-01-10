//
//  ViewController.swift
//  CoreDataCRUD
//
//  Created by Francesca Valeria Haro Dávila on 1/9/19.
//  Copyright © 2019 Belatrix. All rights reserved.
//

import UIKit
import CoreData

class StudentViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  
  var people: [NSManagedObject] = []
  
  @IBAction func addName(_ sender: Any) {
    
    let alert = UIAlertController(title: "New Student", message: "Add a new student", preferredStyle: .alert)
    
    alert.addTextField(configurationHandler: { (textFieldName) in textFieldName.placeholder = "name" })
    alert.addTextField(configurationHandler: { (textFieldId) in
      textFieldId.placeholder = "ID"
      textFieldId.keyboardType = UIKeyboardType.numberPad
    })
    
    let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
      
      guard let textField = alert.textFields?.first,
        let nameToSave = textField.text else {
          return
      }
      
      guard let textFieldID = alert.textFields?[1],
        let idToSave = textFieldID.text else {
          return
      }
      alert.textFields?[1].keyboardType = UIKeyboardType.numberPad
      
      self.save(name: nameToSave, id: Int16(idToSave)!)
      self.tableView.reloadData()
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .default)
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true)
  }
  
  //insert
  func save(name: String, id : Int16) {

    let person = CoreDataManager.sharedManager.insertPerson(name: name, id: id)

    if person != nil {
      people.append(person!)
      tableView.reloadData()
    }
  }
  
  @IBAction func deleteById(_ sender: Any) {
    
    let alert = UIAlertController(title: "Delete by ID", message: "Enter ID", preferredStyle: .alert)
    
    let deleteAction = UIAlertAction(title: "Delete", style: .default) { [unowned self] action in
      guard let textField = alert.textFields?.first , let itemToDelete = textField.text else {
        return
      }

      self.deleteById(id: itemToDelete)
      self.tableView.reloadData()
      
    }

    let cancelAciton = UIAlertAction(title: "Cancel", style: .default)

    alert.addTextField()
    alert.addAction(deleteAction)
    alert.addAction(cancelAciton)
    
    present(alert, animated: true, completion: nil)
  }
  
  func deleteById(id: String) {
    
    let arrRemovedObjects = CoreDataManager.sharedManager.deleteById(id: id)
    people = people.filter({ (param) -> Bool in
      
      if (arrRemovedObjects?.contains(param as! Person))!{
        return false
      }else{
        return true
      }
    })
    
  }
  
  func fetchAllPersons(){
    
    if CoreDataManager.sharedManager.fetchAllPersons() != nil{
      
      people = CoreDataManager.sharedManager.fetchAllPersons()!
      
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchAllPersons()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    tableView.register(UITableViewCell.self,
                       forCellReuseIdentifier: "Cell")
  }
  
  func delete(person : Person){
    CoreDataManager.sharedManager.delete(person: person)
  }
  
  func update(name:String, id : Int16, person : Person) {
    CoreDataManager.sharedManager.update(name: name, id: id, person: person)
  }
}

extension StudentViewController: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return people.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let person = people[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                             for: indexPath)
    cell.textLabel?.text = person.value(forKeyPath: "name") as? String
    return cell
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
    
    let person = people[indexPath.row]
    
    let alert = UIAlertController(title: "Update Name",
                                  message: "Update Name",
                                  preferredStyle: .alert)
    
    alert.addTextField(configurationHandler: { (textFieldName) in
      
      textFieldName.placeholder = "name"
      
      textFieldName.text = person.value(forKey: "name") as? String
      
    })
  
    alert.addTextField(configurationHandler: { (textFieldID) in
      
      textFieldID.keyboardType = UIKeyboardType.numberPad
      textFieldID.placeholder = "ID"
      textFieldID.text = "\(person.value(forKey: "id") as? Int16 ?? 0)"
    })
    
    let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
      // delete item at indexPath
      self.delete(person : person as! Person)
      self.people.remove(at: (self.people.index(of: person))!)
      self.tableView.reloadData()
    }
    
    let editAction = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
      
      let updateAction = UIAlertAction(title: "Update", style: .default) { [unowned self] action in
        
        guard let textField = alert.textFields?[0],
          let nameToSave = textField.text else {
            return
        }
        
        guard let textFieldID = alert.textFields?[1],
          let IDToSave = textFieldID.text else {
            return
        }
        
        self.update(name : nameToSave, id: Int16(IDToSave)!, person : person as! Person)
        
        self.tableView.reloadData()
        
      }
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .default)
      
      alert.addAction(cancelAction)
      alert.addAction(updateAction)
      
      self.present(alert, animated: true)
      
    }
    
    editAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
    deleteAction.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    return [deleteAction, editAction]
    
  }
}

