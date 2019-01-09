//
//  StudentPresenter.swift
//  CoreDataCRUD
//
//  Created by Francesca Valeria Haro Dávila on 1/9/19.
//  Copyright © 2019 Belatrix. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
  
  
  static let sharedManager = CoreDataManager()
  private init() {}
  
  lazy var persistentContainer: NSPersistentContainer = {
    
    let container = NSPersistentContainer(name: "CoreDataCRUD")
    
    
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  /*Save*/
  func saveContext () {
    
    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
    if managedContext.hasChanges {
      do {
        try managedContext.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
  /*Insert*/
  func insertPerson(name: String, id: Int16) -> Person?{
    
    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "Person",
                                            in: managedContext)!
    let person = NSManagedObject(entity: entity,
                                 insertInto: managedContext)
    person.setValue(name, forKey: "name")
    person.setValue(id, forKey: "id")
    
    do {
      try managedContext.save()
      return person as? Person
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
      return nil
    }
  }
  
  /*Update*/
  func update(name: String, id: Int16, person: Person) {
    
    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
    
    do {
      person.setValue(name, forKey: "name")
      person.setValue(id, forKey: "id")
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save \(error), \(error.userInfo)")
    }
  }

  /*Delete*/
  func delete (person: Person) {
    
    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
    
    do {
      managedContext.delete(person)
      try managedContext.save()
    } catch {
      print(error)
    }
  }
  
  /*Fetch*/
  func fetchAllPersons() ->[Person]? {
    
    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject> (entityName: "Person")
    
    do {
      let people = try managedContext.fetch(fetchRequest)
      return people as? [Person]
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
      return nil
    }
  }
  
  /*Delete by ID*/
  
  func deleteById (id: String ) -> [Person]? {
    
    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject> (entityName: "Person")
    
    fetchRequest.predicate = NSPredicate(format: "id == %@", id)
    
    do {
      let item = try managedContext.fetch(fetchRequest)
      var arrRemovePeople = [Person] ()
      for i in item {
        managedContext.delete(i)
        try managedContext.save()
        arrRemovePeople.append(i as! Person)
      }
      return arrRemovePeople
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
      return nil
    }
  }  
}
