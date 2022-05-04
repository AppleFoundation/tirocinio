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
    
    private var context : NSManagedObjectContext

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
        
        self.context = self.persistentContainer.viewContext
        
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
    
    func addValigia(categoria: String, lunghezza: Int, larghezza: Int, profondita: Int, nome:String, tara: Int, utilizzato:Bool){
        print("Provo ad aggiungere la valigia...")
        let entity = NSEntityDescription.entity(forEntityName: "Valigia", in: self.context)
        if(loadFromNomeCategoria(nome: nome, categoria: categoria).isEmpty){
            let newValigia = Valigia(entity: entity!, insertInto: self.context)
            newValigia.nome = nome
            newValigia.categoria = categoria
            newValigia.lunghezza = Int32(lunghezza)
            newValigia.larghezza = Int32(larghezza)
            newValigia.profondita = Int32(profondita)
            newValigia.tara = Int32(tara)
            newValigia.utilizzato = utilizzato
            newValigia.volume = newValigia.profondita * newValigia.lunghezza * newValigia.larghezza
            newValigia.id = UUID()
            self.saveContext()
            print("Valigia salvata!")
        }else{
            print("Questa valigia è già presente!")
        }
    }
    
    func loadAllValigie() -> [Valigia] { //potremmo fargli ritornare l'array anziche niente ahah
        print("Recupero tutte le valigie dal context...")
        
        let request: NSFetchRequest<Valigia> = NSFetchRequest(entityName: "Valigia")
        // Questa proprietà, che di default è true, permette di recuperare gli oggetti in maniera non completa. Questo ti permette di ottimizzare i tempi di recupero degli oggetti nel caso in cui il context sia composto da più di 1k managed object.
                
        //  In pratica, con la proprietà uguale a true, vengono recuperati gli oggetti ma i valori delle loro proprietà vengono mantenuti in cache e recuperati solo quando d’effettivo bisogno (cioè quando ci accedi).
                
        //  Nel nostro caso, dato che stiamo leggendo i valori degli oggetti, questa proprietà risulterebbe inutile dato che vogliamo leggere immediatamente i valori. Quindi, a valore = false, significa che gli oggetti vengono recuperati per interi.
        request.returnsObjectsAsFaults = false
        
//        /*let valigie = */self.loadValigieFromFetchRequest(request: request)
        return self.loadValigieFromFetchRequest(request: request)
    }
    
    func loadFromNomeCategoria(nome: String, categoria: String) -> [Valigia] {
        
        print("Controllo se la Valigia esiste...")
        let request: NSFetchRequest <Valigia> = NSFetchRequest(entityName: "Valigia")
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "nome = %@ AND categoria = %@", nome, categoria)
        request.predicate = predicate
        
        let valigie = self.loadValigieFromFetchRequest(request:request)
        
        print("SONO IN LOAD NOME CATEGORIA")
        for x in valigie {
            let valigia = x
            print("Valigia \(valigia.nome!), volume \(valigia.volume), id \(String(describing: valigia.id))")
        }
        
        return valigie
    }
    
    func loadValigieFromFetchRequest(request: NSFetchRequest<Valigia>) -> [Valigia] {
        var array = [Valigia] ()
        do{
            array = try self.context.fetch(request)
            guard array.count > 0 else {print("Non ci sono elementi da leggere "); return [] }
            
            for x in array {
                let valigia = x
                print("Valigia \(valigia.nome!), volume \(valigia.volume), id \(String(describing: valigia.id))")
            }
            
        }catch let errore{
            print("Problema nella esecuzione della FetchRequest")
            print("\(errore)")
        }
        return array
    }
    
    func deleteValigia(nome: String, categoria: String) {
        let valigia = self.loadFromNomeCategoria(nome: nome, categoria: categoria)
        
        if (valigia.count>0){
            self.context.delete(valigia[0])
            // per ipotesi nome e categoria sono le chiavi, per cui non ci possono essere duplicati su questi attributi, dunque l'array sarà composto da un unico valore
            print("Valigie: \(String(describing: valigia[0].nome))")
            self.saveContext()
        }
    }

}
