//
//  PersistenteManager.swift
//  tirocinio
//
//  Created by Cristian Cerasuolo on 29/04/22.
//

import Foundation
import CoreData
import SwiftUI

class PersistenceManager: ObservableObject {
    
    static let shared: PersistenceManager = PersistenceManager()

    // An instance of NSPersistentContainer includes all objects needed to represent a functioning Core Data stack, and provides convenience methods and properties for common patterns.
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer (name: "model")
        
        // Load stores from the storeDescriptions property that have not already been successfully added to the container. The completion handler is called once for each store that succeeds or fails.
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init(){
        let center = NotificationCenter.default
        let notification = UIApplication.willResignActiveNotification
        
        center.addObserver(forName: notification, object: nil, queue: nil) { [weak self] _ in
            guard let self = self else { return }
            
            if self.persistentContainer.viewContext.hasChanges {
                try? self.persistentContainer.viewContext.save()
            }
        }
    }
    
    //     for later usage
    func saveContext() {
      // ViewContext is a special mangaed object context which is designated for use only on the main thread. Tou'll use this one to save any unsaved data.
      let context = persistentContainer.viewContext
      // 2
      if context.hasChanges {
        do {
          // 3
          try context.save()
        } catch {
          // 4
          // The context couldn't be saved.
          // You should add your own error handling here.
          let nserror = error as NSError
          fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
      }
    }
    
    //Instructs the app to call the save method you previously added when the app goes into the background
    func sceneDidEnterBackground(_ scene: UIScene){
        saveContext()
    }

}
