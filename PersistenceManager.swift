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
    
    //Retunr the context
    func getContext() -> NSManagedObjectContext{
        return self.context
    }
    //ADD
    func addValigia(categoria: String, lunghezza: Int, larghezza: Int, profondita: Int, nome: String, tara: Int, utilizzato:Bool){
        let entity = NSEntityDescription.entity(forEntityName: "Valigia", in: self.context)
        if(loadValigieFromNomeCategoria(nome: nome, categoria: categoria).isEmpty){
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
    
    func addValigiaViaggiante(oggettiInViaggio: [Oggetto], valigia: Valigia, viaggio: Viaggio){
        let entity = NSEntityDescription.entity(forEntityName: "ValigiaViaggiante", in: self.context)
        if(loadValigieViaggiantiFromViaggioValigia(viaggio: viaggio, valigia: valigia).isEmpty){
            let newValigiaViaggiante = ValigiaViaggiante(entity: entity!, insertInto: self.context)
            newValigiaViaggiante.oggettiviaggio?.mutableSetValue(forKey: "oggettiviaggio").addObjects(from: oggettiInViaggio)
                print(newValigiaViaggiante.oggettiviaggio)//DEBUG
            newValigiaViaggiante.valigiariferimento = valigia
            newValigiaViaggiante.viaggioriferimento = viaggio
            newValigiaViaggiante.id = UUID()
            valigia.utilizzato = true //se usiamo la valigia allora la mettiamo come utilizzata
            self.saveContext()
            print("ValigiaViaggiante salvata!")
        }else{
            print("Questa valigia è già presente!")
        }
    }

    func addViaggio(data: Date, nome: String){
        let entity = NSEntityDescription.entity(forEntityName: "Viaggio", in: self.context)
        
        if(loadViaggiFromNome(nome: nome).isEmpty){
            let newViaggio = Viaggio(entity: entity!, insertInto: self.context)
            
            newViaggio.nome = nome
            newViaggio.id = UUID()
            newViaggio.data = data
            
            self.saveContext()
            print("Viaggio salvato!")
        }else{
            print("Questo viaggio è già stato fatto")
        }
    }
    
    func addOggetto(categoria: String, larghezza: Int, lunghezza: Int, profondita: Int, peso: Int, nome: String){
        let entity = NSEntityDescription.entity(forEntityName: "Oggetto", in: self.context)
        
        if(loadOggettiFromNomeCategoria(nome: nome, categoria: categoria).isEmpty){
            let newOggetto = Oggetto(entity: entity!, insertInto: self.context)
            
            newOggetto.categoria = categoria
            newOggetto.nome = nome
            newOggetto.larghezza = Int32(larghezza)
            newOggetto.lunghezza = Int32(lunghezza)
            newOggetto.profondita = Int32(profondita)
            newOggetto.peso = Int32(peso)
            newOggetto.volume = Int32(larghezza * lunghezza * profondita)
            newOggetto.id = UUID()
            
            self.saveContext()
            print("Oggetto salvato!")
        }else{
            print("Questo oggetto esiste già")
        }
    }
    
    //SELECTION
    func loadViaggiFromFetchRequest(request: NSFetchRequest<Viaggio>) -> [Viaggio] {
        var array = [Viaggio] ()
        do{
            
            array = try self.context.fetch(request)
        
            guard array.count > 0 else {print("Non ci sono elementi da leggere "); return [] }
            
//            for x in array {
//                let viaggio = x
//                print("Viaggio \(viaggio.nome!), data \(String(describing: viaggio.data)), id \(String(describing: viaggio.id))")
//            }
            
        }catch let errore{
            print("Problema nella esecuzione della FetchRequest")
            print("\(errore)")
        }
        return array
    }
    
    func loadValigieViaggiantiFromFetchRequest(request: NSFetchRequest<ValigiaViaggiante>) -> [ValigiaViaggiante] {
        var array = [ValigiaViaggiante]()
        do{
            array = try self.context.fetch(request)
        
            guard array.count > 0 else {print("Non ci sono elementi da leggere "); return [] }
            
            for x in array {
                let valigia = x
                print("Valigia Viaggiante \n Contenitore:\(String(describing: valigia.valigiariferimento!.nome))\n Viaggio:\(valigia.viaggioriferimento?.nome)")
            }
            
        }catch let errore{
            print("Problema nella esecuzione della FetchRequest")
            print("\(errore)")
        }
        return array
    }
    
    func loadValigieFromFetchRequest(request: NSFetchRequest<Valigia>) -> [Valigia] {
        var array = [Valigia] ()
        do{
            array = try self.context.fetch(request)
            guard array.count > 0 else {print("Non ci sono elementi da leggere "); return [] }
            
//            for x in array {
//                let valigia = x
//                print("Valigia \(valigia.nome!), volume \(valigia.volume)")
//            }
            
        }catch let errore{
            print("Problema nella esecuzione della FetchRequest")
            print("\(errore)")
        }
        return array
    }
    
    func loadOggettiFromFetchRequest(request: NSFetchRequest<Oggetto>) -> [Oggetto]{
        var array = [Oggetto] ()
        do{
            array = try self.context.fetch(request)
            guard array.count > 0 else {print("Non ci sono elementi da leggere "); return [] }
            
        }catch let errore{
            print("Problema nella esecuzione della FetchRequest")
            print("\(errore)")
        }
        return array
    }
    
    func loadValigieFromNomeCategoria(nome: String, categoria: String) -> [Valigia] {
        let request: NSFetchRequest <Valigia> = NSFetchRequest(entityName: "Valigia")
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "nome = %@ AND categoria = %@", nome, categoria)
        request.predicate = predicate
        
        let valigie = self.loadValigieFromFetchRequest(request:request)
        
        return valigie
    }
    
    func loadValigieViaggiantiFromViaggioValigia(viaggio: Viaggio, valigia: Valigia) -> [ValigiaViaggiante] {
        let request: NSFetchRequest <ValigiaViaggiante> = NSFetchRequest(entityName: "ValigiaViaggiante")
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "viaggioriferimento = %@ AND valigiariferimento = %@", viaggio, valigia)
        request.predicate = predicate
        
        let valigie = self.loadValigieViaggiantiFromFetchRequest(request:request)
        
        return valigie
    }
    
    func loadViaggiFromNome(nome: String) -> [Viaggio] {
        let request: NSFetchRequest <Viaggio> = NSFetchRequest(entityName: "Viaggio")
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "nome = %@", nome)
        request.predicate = predicate
        
        let viaggi = self.loadViaggiFromFetchRequest(request:request)
        return viaggi
    }
    
    func loadOggettiFromNomeCategoria(nome: String, categoria: String) -> [Oggetto] {
        let request: NSFetchRequest <Oggetto> = NSFetchRequest(entityName: "Oggetto")
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "nome = %@ AND categoria = %@", nome, categoria)
        request.predicate = predicate
        
        let oggetti = self.loadOggettiFromFetchRequest(request:request)
        
        
        return oggetti
    }
    
    func loadOggettiFromCategoria(categoria: String) -> [Oggetto] {
        let request: NSFetchRequest <Oggetto> = NSFetchRequest(entityName: "Oggetto")
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "categoria = %@", categoria)
        request.predicate = predicate
        
        let oggetti = self.loadOggettiFromFetchRequest(request:request)
        
        
        
        
        return oggetti
    }
    
    func loadAllViaggi() -> [Viaggio] {
        let request: NSFetchRequest<Viaggio> = NSFetchRequest(entityName: "Viaggio")
        request.returnsObjectsAsFaults = false
        
        return self.loadViaggiFromFetchRequest(request: request)
    }
    
    func loadAllValigie() -> [Valigia] {
        
        let request: NSFetchRequest<Valigia> = NSFetchRequest(entityName: "Valigia")
        // Questa proprietà, che di default è true, permette di recuperare gli oggetti in maniera non completa. Questo ti permette di ottimizzare i tempi di recupero degli oggetti nel caso in cui il context sia composto da più di 1k managed object.
                
        //  In pratica, con la proprietà uguale a true, vengono recuperati gli oggetti ma i valori delle loro proprietà vengono mantenuti in cache e recuperati solo quando d’effettivo bisogno (cioè quando ci accedi).
                
        //  Nel nostro caso, dato che stiamo leggendo i valori degli oggetti, questa proprietà risulterebbe inutile dato che vogliamo leggere immediatamente i valori. Quindi, a valore = false, significa che gli oggetti vengono recuperati per interi.
        request.returnsObjectsAsFaults = false
        
//        /*let valigie = */self.loadValigieFromFetchRequest(request: request)
        return self.loadValigieFromFetchRequest(request: request)
    }
    
    func loadAllOggetti() -> [Oggetto]{
        let request: NSFetchRequest<Oggetto> = NSFetchRequest(entityName: "Oggetto")
        request.returnsObjectsAsFaults = false
    
        return self.loadOggettiFromFetchRequest(request: request)
    }
    
    func loadAllValigieViaggianti() -> [ValigiaViaggiante] {
        let request: NSFetchRequest<ValigiaViaggiante> = NSFetchRequest(entityName: "ValigiaViaggiante")
        request.returnsObjectsAsFaults = false
        
        return self.loadValigieViaggiantiFromFetchRequest(request: request)
    }
    
    //DELETE
    func deleteValigia(nome: String, categoria: String) {
        let valigie = self.loadValigieFromNomeCategoria(nome: nome, categoria: categoria)
        
        if (valigie.count>0){
            self.context.delete(valigie[0])
            // per ipotesi nome e categoria sono le chiavi, per cui non ci possono essere duplicati su questi attributi, dunque l'array sarà composto da un unico valore
            print("Valigie: \(String(describing: valigie[0].nome))")
            self.saveContext()
        }
    }
    
    func deleteValigiaViaggiante(viaggio: Viaggio, valigia: Valigia) {
        let valigieviaggianti = self.loadValigieViaggiantiFromViaggioValigia(viaggio: viaggio, valigia: valigia)
        
        if(valigieviaggianti.count > 0){
            self.context.delete(valigieviaggianti[0])
            
            self.saveContext()
        }
    }
    
    func deleteViaggio(nome: String){
        let viaggi = self.loadViaggiFromNome(nome: nome)
        
        if(viaggi.count > 0){
            self.context.delete(viaggi[0])
            print("Viaggi: \(String(describing: viaggi[0].nome))")
            self.saveContext()
        }
    }
    
    func deleteOggetto(nome: String, categoria: String){
        let oggetti = self.loadOggettiFromNomeCategoria(nome: nome, categoria: categoria)
        
        if(oggetti.count > 0){
            self.context.delete(oggetti[0])
            print("Oggetti: \(String(describing: oggetti[0].nome))")
            self.saveContext()
        }
    }
    
    //UPDATE -> Vedremo poi...

    func updateOggetto(nome: String, categoria: String, newQuantita: Int){
        let oggetti = self.loadOggettiFromNomeCategoria(nome: nome, categoria: categoria)
        
        if(oggetti.count > 0){
            oggetti[0].quantita = Int32(newQuantita)
            self.saveContext()
        }
    }

}
