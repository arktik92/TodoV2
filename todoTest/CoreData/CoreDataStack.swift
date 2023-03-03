//
//  CoreDataStack.swift
//  todoTest
//
//  Created by Esteban SEMELLIER on 01/03/2023.
//

import Foundation
import CoreData

class CoreDataStack {
    public init() {
           
       }
       
       lazy var persistentContainer: NSPersistentContainer = {
           let container = NSPersistentContainer(
           name:"CoreDataUnitTesting")
           container.loadPersistentStores(
             completionHandler: { (storeDescription, error) in
               if let error = error as NSError? {
                   fatalError("Unresolved error \(error),\(error.userInfo)")
               }
           })
           return container
       }()
       
       var applicationDocumentsDirectory: NSURL = {
           let urls = FileManager.default.urls(for:
             .documentDirectory, in: .userDomainMask)
           return urls[urls.count - 1] as NSURL
       }()
       
       public var managedObjectModel: NSManagedObjectModel = {
           var modelPath = Bundle.main.path(
             forResource: "CoreDataUnitTesting",
             ofType: "momd")
           var modelURL = NSURL.fileURL(withPath: modelPath!)
           var model = NSManagedObjectModel(contentsOf: modelURL)!
           return model
       }()
       
       public lazy var persistentStoreCoordinator:     NSPersistentStoreCoordinator = {
           
           let url = self.applicationDocumentsDirectory.appendingPathComponent("CoreDataUnitTesting.sqlite")
           var options = [NSInferMappingModelAutomaticallyOption: true, NSMigratePersistentStoresAutomaticallyOption: true]
           
           var psc = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
           do {
               try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName:nil, at: url, options: options)
           } catch {
               NSLog("Error when creating persistent store \(error)")
               fatalError()
           }
           return psc
       }()
       
       public lazy var rootContext: NSManagedObjectContext = {
           var context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
           context.persistentStoreCoordinator = self.persistentStoreCoordinator
           return context
       }()
       
       // MARK: - Core Data Saving support
       
       func saveContext () {
           let context = persistentContainer.viewContext
           if context.hasChanges {
               do {
                   try context.save()
               } catch {
                   let nserror = error as NSError
                   fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
               }
           }
       }
}

class TestCoreDataStack: CoreDataStack {
  override init() {
    super.init()
    self.persistentStoreCoordinator = {
      let psc = NSPersistentStoreCoordinator(
      managedObjectModel: self.managedObjectModel)
      do {
        try psc.addPersistentStore(ofType:
        NSInMemoryStoreType,configurationName: nil,
        at: nil, options:nil)
      } catch {
        fatalError()
      }
      return psc
    }()
  }
}
