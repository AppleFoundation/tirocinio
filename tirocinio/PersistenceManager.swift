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
    
    
    
    func addViaggio(data: Date, nome: String, tipo: String){
        let entity = NSEntityDescription.entity(forEntityName: "Viaggio", in: self.context)
        
        if(loadViaggiFromNome(nome: nome).isEmpty){
            let newViaggio = Viaggio(entity: entity!, insertInto: self.context)
            
            newViaggio.nome = nome
            newViaggio.id = UUID()
            newViaggio.data = data
            newViaggio.tipo = tipo
            newViaggio.allocaPer = false //volume
            
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
    
    func addOggettoViaggiante(oggetto: Oggetto, viaggio: Viaggio){
        let entity = NSEntityDescription.entity(forEntityName: "OggettoViaggiante", in: self.context)
        
        
        
        //controllo se esiste nel viaggio un oggetto viaggiante che referenzia quell'oggetto
        if !self.checkExistingOggettoInViaggio(oggetto: oggetto, viaggio: viaggio){
            let newOggettoViaggiante = OggettoViaggiante(entity: entity!, insertInto: self.context)
            
            newOggettoViaggiante.id = UUID()
            newOggettoViaggiante.oggettoRef = oggetto
            newOggettoViaggiante.viaggioRef = viaggio
            newOggettoViaggiante.quantitaAllocata = 0
            newOggettoViaggiante.quantitaInViaggio = 1
            
            
            self.saveContext()
            print("Oggetto viaggiante salvato!")
        }
        
        
    }
    
    func addOggettoInValigia(oggetto: OggettoViaggiante, valigia: ValigiaViaggiante?, viaggio: Viaggio) -> OggettoInValigia{
        let entity = NSEntityDescription.entity(forEntityName: "OggettoInValigia", in: self.context)
        
        let new = OggettoInValigia(entity: entity!, insertInto: self.context)
        new.id = UUID()
        new.contenitore = valigia
        new.oggettoViaggianteRef = oggetto
        new.quantitaInValigia = 0
        new.viaggioRef = viaggio
        
        self.saveContext()
        
        return new
    }
    
    func addValigiaViaggiante(valigia: Valigia, viaggio: Viaggio, pesoMassimo: Int){
        let entity = NSEntityDescription.entity(forEntityName: "ValigiaViaggiante", in: self.context)
        
        
        let newValigiaViaggiante = ValigiaViaggiante(entity: entity!, insertInto: self.context)
        
        newValigiaViaggiante.id = UUID()
        newValigiaViaggiante.valigiaRef = valigia
        newValigiaViaggiante.viaggioRef = viaggio
        newValigiaViaggiante.pesoMassimo = Int32(pesoMassimo) //a cosa serve? Forse per i limiti di peso
        newValigiaViaggiante.pesoAttuale = 0//come lo determino?
        newValigiaViaggiante.volumeAttuale = 0 //volume occupato internamente. 0 inizialmente
        newValigiaViaggiante.volumeMassimo = valigia.volume //il volume massimo è rappresentato dal volume massimo della valigia a cui si riferisce questa istanza
        newValigiaViaggiante.addToContenuto([])//nessun contenuto inizialmente
        
        valigia.utilizzato = true //se usiamo la valigia allora la mettiamo come utilizzata
        
        aggiornaPesoMassimoValigieViaggianti(valigia: valigia, viaggio: viaggio, pesoMassimo: pesoMassimo)
        
        self.saveContext()
        print("ValigiaViaggiante salvata!")
        
    }
    
    func aggiornaPesoMassimoValigieViaggianti(valigia: Valigia, viaggio: Viaggio, pesoMassimo: Int){
        let valigieFinOra = loadValigieViaggiantiFromViaggioValigia(viaggio: viaggio, valigia: valigia)
        for valigiaOra in valigieFinOra {
            valigiaOra.pesoMassimo = Int32(pesoMassimo)
        }
        self.saveContext()
    }
    
    //SELECTION
    func loadViaggiFromFetchRequest(request: NSFetchRequest<Viaggio>) -> [Viaggio] {
        var array = [Viaggio] ()
        do{
            
            array = try self.context.fetch(request)
            
            guard array.count > 0 else {
                //                print("Non ci sono elementi da leggere ")
                return [] }
            
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
            
            guard array.count > 0 else {
                //                print("Non ci sono elementi da leggere ")
                return [] }
            
            //            for x in array {
            //                let valigia = x.valigiaRef
            //                let viaggio = x.viaggioRef
            //                print("Valigia Viaggiante \n Contenitore: \(valigia?.nome ?? "Nome")\n Viaggio: \(viaggio?.nome ?? "Viaggio")")
            //            }
            //
        }catch let errore{
            print("Problema nella esecuzione della FetchRequest")
            print("\(errore)")
        }
        return array
    }
    
    func loadOggettiViaggiantiFromFetchRequest(request: NSFetchRequest<OggettoViaggiante>) -> [OggettoViaggiante] {
        var array = [OggettoViaggiante]()
        do{
            array = try self.context.fetch(request)
            
            guard array.count > 0 else {
                //                print("Non ci sono elementi da leggere ")
                return [] }
            //
            //            for x in array {
            //                let oggetto = x
            //                print("Oggetto Viaggiante \n OggettoRef:\(String(describing: oggetto.oggettoRef))\n ViaggioRef:\(String(describing: oggetto.viaggioRef))")
            //            }
            
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
            guard array.count > 0 else {
                //                print("Non ci sono elementi da leggere ")
                return [] }
            
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
            guard array.count > 0 else {
                //                print("Non ci sono elementi da leggere ")
                return [] }
            
        }catch let errore{
            print("Problema nella esecuzione della FetchRequest")
            print("\(errore)")
        }
        return array
    }
    
    func loadOggettiInValigiaFromFetchRequest(request: NSFetchRequest<OggettoInValigia>) -> [OggettoInValigia]{
        var array = [OggettoInValigia]()
        
        do{
            array = try self.context.fetch(request)
            guard array.count > 0 else {
                //                print("Non ci sono elementi da leggere ")
                return [] }
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
    
    func loadValigieFromCategoria(categoria: String) -> [Valigia] {
        let request: NSFetchRequest <Valigia> = NSFetchRequest(entityName: "Valigia")
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "categoria = %@", categoria)
        request.predicate = predicate
        
        let valigie = self.loadValigieFromFetchRequest(request:request)
        
        return valigie
    }
    
    func loadValigieViaggiantiFromViaggioValigia(viaggio: Viaggio, valigia: Valigia) -> [ValigiaViaggiante] {
        let request: NSFetchRequest <ValigiaViaggiante> = NSFetchRequest(entityName: "ValigiaViaggiante")
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "viaggioRef = %@ AND valigiaRef = %@", viaggio , valigia)
        request.predicate = predicate
        
        let valigie = self.loadValigieViaggiantiFromFetchRequest(request:request)
        
        return valigie
    }
    
    func loadValigieViaggiantiFromViaggio(viaggio: Viaggio) -> [ValigiaViaggiante] {
        let request: NSFetchRequest <ValigiaViaggiante> = NSFetchRequest(entityName: "ValigiaViaggiante")
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "viaggioRef = %@", viaggio)
        request.predicate = predicate
        
        let valigie = self.loadValigieViaggiantiFromFetchRequest(request:request)
        
        return valigie
    }
    
    func loadOggettiViaggiantiFromOggettoViaggio(oggettoRef: Oggetto, viaggioRef: Viaggio) -> [OggettoViaggiante]{
        let request: NSFetchRequest <OggettoViaggiante> = NSFetchRequest(entityName: "OggettoViaggiante")
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "oggettoRef = %@ AND viaggioRef = %@", oggettoRef, viaggioRef)
        request.predicate = predicate
        
        let oggetti = self.loadOggettiViaggiantiFromFetchRequest(request:request)
        
        return oggetti
    }
    
    func loadOggettiViaggiantiFromViaggio(viaggioRef: Viaggio) -> [OggettoViaggiante]{
        let request: NSFetchRequest <OggettoViaggiante> = NSFetchRequest(entityName: "OggettoViaggiante")
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "viaggioRef = %@", viaggioRef)
        request.predicate = predicate
        
        let oggetti = self.loadOggettiViaggiantiFromFetchRequest(request:request)
        
        return oggetti
    }
    
    func loadOggettiInValigiaFromViaggio(viaggio: Viaggio) -> [OggettoInValigia]{
        let request: NSFetchRequest <OggettoInValigia> = NSFetchRequest(entityName: "OggettoInValigia")
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "viaggioRef = %@", viaggio)
        request.predicate = predicate
        
        let oggettiinvaligia: [OggettoInValigia] = self.loadOggettiInValigiaFromFetchRequest(request: request)
        
        return oggettiinvaligia
    }
    
    func loadOggettiInValigiaFromViaggioOggetto(viaggio: Viaggio, oggetto: Oggetto) -> [OggettoInValigia]{
        
        let oggettiViaggianti = self.loadOggettiViaggiantiFromOggettoViaggio(oggettoRef: oggetto, viaggioRef: viaggio)
        
        if(oggettiViaggianti.isEmpty == false){
            let oggettoViaggiante = self.loadOggettiViaggiantiFromOggettoViaggio(oggettoRef: oggetto, viaggioRef: viaggio)[0]
            
            let request: NSFetchRequest <OggettoInValigia> = NSFetchRequest(entityName: "OggettoInValigia")
            request.returnsObjectsAsFaults = false
            
            let predicate = NSPredicate(format: "viaggioRef = %@ AND oggettoViaggianteRef = %@", viaggio, oggettoViaggiante)
            request.predicate = predicate
            
            let oggettiinvaligia: [OggettoInValigia] = self.loadOggettiInValigiaFromFetchRequest(request: request)
            
            return oggettiinvaligia
        }else{
            return []
        }
        
        
    }
    
    func loadOggettiInValigiaFromValigiaOggetto(valigiaV: ValigiaViaggiante, oggettoV: OggettoViaggiante) -> [OggettoInValigia]{
        let request: NSFetchRequest <OggettoInValigia> = NSFetchRequest(entityName: "OggettoInValigia")
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "contenitore = %@ AND oggettoViaggianteRef = %@", valigiaV, oggettoV)
        request.predicate = predicate
        
        let oggettiinvaligia: [OggettoInValigia] = self.loadOggettiInValigiaFromFetchRequest(request: request)
        
        return oggettiinvaligia
    }
    
    func loadOggettiInValigiaFromValigiaViaggianteViaggio(valigiaviaggiante: ValigiaViaggiante, viaggio: Viaggio) -> [OggettoInValigia]{
        let request: NSFetchRequest <OggettoInValigia> = NSFetchRequest(entityName: "OggettoInValigia")
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "contenitore = %@ AND viaggioRef = %@", valigiaviaggiante, viaggio)
        request.predicate = predicate
        
        let oggetti = self.loadOggettiInValigiaFromFetchRequest(request:request)
        
        return oggetti
    }
    
    func loadOggettiInValigiaFromValigia(valigia: ValigiaViaggiante) -> [OggettoInValigia]{
        let request: NSFetchRequest <OggettoInValigia> = NSFetchRequest(entityName: "OggettoInValigia")
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "contenitore = %@", valigia)
        request.predicate = predicate
        
        let oggettiinvaligia: [OggettoInValigia] = self.loadOggettiInValigiaFromFetchRequest(request: request)
        
        return oggettiinvaligia
    }
    
    func loadValigieViaggiantiFromViaggioWithout0SYSTEM(viaggioRef: Viaggio) -> [ValigiaViaggiante]{
        let request: NSFetchRequest <ValigiaViaggiante> = NSFetchRequest(entityName: "ValigiaViaggiante")
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "viaggioRef = %@ AND valigiaRef <> %@", viaggioRef, self.loadValigieFromCategoria(categoria: "0SYSTEM")[0])
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
    
    func loadOggettiFromID(ID: String) -> [Oggetto] {
        
        let request: NSFetchRequest <Oggetto> = NSFetchRequest(entityName: "Oggetto")
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "id = %@", ID)
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
        let predicate = NSPredicate(format: "categoria <> '0SYSTEM'")
        request.predicate = predicate
        
        //        /*let valigie = */self.loadValigieFromFetchRequest(request: request)
        return self.loadValigieFromFetchRequest(request: request)
    }
    
    func loadAllOggetti() -> [Oggetto]{
        let request: NSFetchRequest<Oggetto> = NSFetchRequest(entityName: "Oggetto")
        request.returnsObjectsAsFaults = false
        
        return self.loadOggettiFromFetchRequest(request: request)
    }
    
    func loadAllOggettiInValigia() -> [OggettoInValigia]{
        let request: NSFetchRequest<OggettoInValigia> = NSFetchRequest(entityName: "OggettoInValigia")
        request.returnsObjectsAsFaults = false
        
        return self.loadOggettiInValigiaFromFetchRequest(request: request)
    }
    
    func loadAllCategorieOggetti() -> [String]{
        let request: NSFetchRequest<Oggetto> = NSFetchRequest(entityName: "Oggetto")
        request.returnsObjectsAsFaults = false
        
        let oggettiDaDB = self.loadOggettiFromFetchRequest(request: request)
        
        var categorieLista = Set<String>.init()
        
        for oggetto in oggettiDaDB {
            categorieLista.insert(oggetto.categoria!)
        }
        
        var categorieArray = Array<String>.init()
        
        for singolaCat in categorieLista{
            categorieArray.append(singolaCat)
        }
        
        return categorieArray
    }
    
    func loadAllCategorieValigie() -> [String]{
        let request: NSFetchRequest<Valigia> = NSFetchRequest(entityName: "Valigia")
        request.returnsObjectsAsFaults = false
        
        let valieieDaDB = self.loadValigieFromFetchRequest(request: request)
        
        var categorieLista = Set<String>.init()
        
        for valigia in valieieDaDB {
            if valigia.categoria != "0SYSTEM"{//system è una cateogria che contiene valigie di utilit come la valigia non allocati
                categorieLista.insert(valigia.categoria!)
            }
        }
        
        var categorieArray = Array<String>.init()
        
        for singolaCat in categorieLista{
            categorieArray.append(singolaCat)
        }
        
        return categorieArray
    }
    
    func loadAllOggettiViaggianti() -> [OggettoViaggiante]{
        let request: NSFetchRequest<OggettoViaggiante> = NSFetchRequest(entityName: "OggettoViaggiante")
        request.returnsObjectsAsFaults = false
        
        return self.loadOggettiViaggiantiFromFetchRequest(request: request)
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
            //            print("Valigie: \(String(describing: valigie[0].nome))")
            self.saveContext()
        }
    }
    
    func deleteValigiaViaggiante(viaggio: Viaggio, valigia: Valigia) {
        let valigieviaggianti = self.loadValigieViaggiantiFromViaggioValigia(viaggio: viaggio, valigia: valigia)
        
        if(valigieviaggianti.count > 0){
            self.context.delete(valigieviaggianti[0])
            valigia.utilizzato = false
            self.saveContext()
        }
    }
    
    func deleteViaggio(nome: String){
        let viaggi = self.loadViaggiFromNome(nome: nome)
        
        if(viaggi.count > 0){
            print("Viaggi: \(String(describing: viaggi[0].nome))")
            PersistenceManager.shared.deleteAllOggettoViaggiante(viaggio: viaggi[0])
            PersistenceManager.shared.deleteAllValigiaViaggiante(viaggio: viaggi[0])
            self.context.delete(viaggi[0])
            self.saveContext()
        }
    }
    
    func deleteAllViaggi(){
        let allViaggi = self.loadAllViaggi()
        
        for viaggio in allViaggi{
            PersistenceManager.shared.deleteViaggio(nome: viaggio.nome ?? "")
        }
    }
    
    func deleteOggettiInValigia(viaggio: Viaggio){
        let oggettiinvaligia = self.loadOggettiInValigiaFromViaggio(viaggio: viaggio)
        
        if(oggettiinvaligia.count > 0){
            
            for oggetto in oggettiinvaligia{
                self.context.delete(oggetto)
            }
            self.saveContext()
        }
    }
    
    func deleteOggetto(nome: String, categoria: String){
        let oggetti = self.loadOggettiFromNomeCategoria(nome: nome, categoria: categoria)
        
        if(!oggetti.isEmpty){
            self.context.delete(oggetti[0])
            self.saveContext()
        }
    }
    
    func deleteOggettoViaggiante(ogetto: Oggetto, viaggio: Viaggio){
        let oggettiViaggianti = self.loadOggettiViaggiantiFromOggettoViaggio(oggettoRef: ogetto, viaggioRef: viaggio)
        
        if(oggettiViaggianti.count > 0){
            self.context.delete(oggettiViaggianti[0])
            self.saveContext()
        }
    }
    
    func deleteAllOggettoViaggiante(viaggio: Viaggio){
        let oggettiViaggianti = self.loadOggettiViaggiantiFromViaggio(viaggioRef: viaggio)
        
        if(oggettiViaggianti.count > 0){
            
            for oggetto in oggettiViaggianti{
                self.context.delete(oggetto)
                
            }
            self.saveContext()
        }
    }
    
    func deleteAllValigiaViaggiante(viaggio: Viaggio){
        let valigieViaggianti = self.loadValigieViaggiantiFromViaggioWithout0SYSTEM(viaggioRef: viaggio)
        
        if(valigieViaggianti.count > 0){
            
            for valigia in valigieViaggianti{
                self.context.delete(valigia)
                
            }
            self.saveContext()
        }
    }
    
    
    func deleteAllValigie(){
        let valigie = self.loadAllValigie()
        
        if(valigie.count > 0){
            
            for valigia in valigie{
                self.context.delete(valigia)
            }
            self.saveContext()
        }
    }
    
    func deleteAllOggetti(){
        let oggetti = self.loadAllOggetti()
        
        if(oggetti.count > 0){
            
            for oggetto in oggetti{
                self.context.delete(oggetto)
            }
            self.saveContext()
        }
    }
    
    //UTILITY
    func allocaOggetti(viaggio: Viaggio, ordinamento: Bool){
        ///FIRST FIT DECREASING
        self.deleteOggettiInValigia(viaggio: viaggio) //elimino le precedenti allocazioni di oggetti in valigia
        
        //definisco la lista dei miei contenitore per quel viaggio
        var bins: [ValigiaViaggiante] = []
        
        let allValigie = loadAllValigie()
        for valigiareale in allValigie{
            if valigiareale.categoria == "0SYSTEM"{
                continue //non aggiungo ai bins la valigia di sistema
            }
            //per ogni valigia vado a vedere le valigie viaggianti associate per il dato viaggio
            bins.append(contentsOf: loadValigieViaggiantiFromViaggioValigia(viaggio: viaggio, valigia: valigiareale))
        }
        for b in bins{
            let oggettiInValigia = self.loadOggettiInValigiaFromValigiaViaggianteViaggio(valigiaviaggiante: b, viaggio: viaggio)
            b.removeFromContenuto(NSSet(array: oggettiInValigia))
            b.volumeAttuale = 0
            b.pesoAttuale = b.valigiaRef?.tara ?? 0
        }
        
        //carico la valigia dei non allocati per farne una pulizia prima del re-allocamento
        let nonallocati: ValigiaViaggiante = self.loadValigieViaggiantiFromViaggioValigia(viaggio: viaggio, valigia: self.loadValigieFromCategoria(categoria: "0SYSTEM")[0])[0]
        nonallocati.removeFromContenuto(NSSet(array: nonallocati.contenuto.array(of: OggettoViaggiante.self)))
        nonallocati.volumeAttuale = 0
        nonallocati.pesoAttuale = 0
        
        //definisco l'insieme degli oggetti che sono definiti per quel viaggio. Non prendo solo quelli allocati perchè ritengo più efficiente rifare l'allocazione avendo oggetti diversi e quindi una possibile allocazione totalmente diversa
        var elements: [OggettoViaggiante] = []
        elements.append(contentsOf: loadOggettiViaggiantiFromViaggio(viaggioRef: viaggio))
        
        ///a questo punto ho tutti i bins di volume differente e tutti gli elementi
        
        switch ordinamento{
        case false:
            print("ALLOCO PER VOLUME")
            allocaPerVolume(bins: bins, elements: elements, nonallocati: nonallocati, viaggio: viaggio)
            break
        case true:
            print("ALLOCO PER PESO")
            allocaPerPeso(bins: bins, elements: elements, nonallocati: nonallocati, viaggio: viaggio)
            break
        }
        
    }
    
    //funzione di supporto alla allocazione per peso
    func allocaPerPeso(bins: [ValigiaViaggiante], elements: [OggettoViaggiante], nonallocati: ValigiaViaggiante, viaggio: Viaggio){
        //ordino gli oggetti in maniera decrescente di priorità di inserimento. Assumo che la priorità sia dettata dal volume
        let descendingelements: [OggettoViaggiante] = elements.sorted(by: {$0.oggettoRef?.peso ?? 0 > $1.oggettoRef?.peso ?? 0})
        
        //Calcolo secondo peso ma devo comunque non superare il volume massimo
        for item in descendingelements{
            item.quantitaAllocata = 0 //reinizializzo
            
            for i in bins.indices{
                //calcolo quante occorrenze di questo item possono essere inserite nel bin attuale e le inserisco
                let pesodisponibile = Int(bins[i].pesoMassimo - bins[i].pesoAttuale)
                let volumedisponibile = Int(bins[i].volumeMassimo - bins[i].volumeAttuale)
                
                var numItemContenibili = Int(pesodisponibile/Int((item.oggettoRef?.peso ?? 0)))
                let numItemContenibiliPerVolume = Int(volumedisponibile/Int((item.oggettoRef?.volume ?? 0)))
                
                if numItemContenibili > 0{//significa che almeno uno lo posso inserire
                    
                    
                    
                    //controllo se nel bin attuale vi è già un oggetto in valigia che si riferisce all'oggetto viaggiante in questione (item)
                    let existing: [OggettoInValigia] = loadOggettiInValigiaFromValigiaOggetto(valigiaV: bins[i], oggettoV: item)
                    var allocabili = 0
                    if numItemContenibili >= numItemContenibiliPerVolume {
                        numItemContenibili = numItemContenibiliPerVolume
                    }
                    if numItemContenibili >= (item.quantitaInViaggio - item.quantitaAllocata){//li posso inserire tutti senza oltrepassare il peso massimo
                        
                        
                        allocabili = Int(item.quantitaInViaggio - item.quantitaAllocata) //alloco quelli che mancano per allocarli tutti
                        
                    }else{//maggiore di 0 ma non posso inserire tutta la quantità dell'item
                        
                        
                        allocabili = numItemContenibili //alloco il possibile
                        
                    }
                    
                    
                    if allocabili != 0{
                        if existing.count > 0{//se esiste già un oggettoinvaligia con quell'item
                    
                            item.quantitaAllocata += Int32(allocabili)
                            existing[0].quantitaInValigia += Int32(allocabili)
                        }else{//nesssun oggetto precedentemente allocato
                            let newallocazione: OggettoInValigia = self.addOggettoInValigia(oggetto: item, valigia: bins[i], viaggio: viaggio)
                            newallocazione.quantitaInValigia = Int32(allocabili)
                            bins[i].addToContenuto(newallocazione)
                            item.quantitaAllocata += Int32(allocabili)
                        }
                        bins[i].pesoAttuale += Int32(allocabili) * (item.oggettoRef?.peso ?? 0)
                        bins[i].volumeAttuale += Int32(allocabili) * (item.oggettoRef?.volume ?? 0)
                    }
                    
                    
                    if item.quantitaAllocata == item.quantitaInViaggio {//se ho allocato tutta la quantità dell'oggetto allora posso evitre di vedere altre valigie
                        break
                    }
                    
                    
                }else{
                    print("Non posso inserire nessun \(item.oggettoRef?.nome ?? "Nome oggetto") nella valigia \(bins[i].valigiaRef?.nome ?? "Nome valigia")")
                }//else -> in questo bin non c'è spazio per nessuna quantità di questo item
                
            }//quando esco dal for potrei aver allocato tutte le quantita dei miei oggetti oppure avere oggetti con quantitallocata<quantitainviaggio
            
            
            //Se dopo aver girato tutti i bins non ho allocato tutte le occorrenze del mio oggetto sono costretto a metterlo negli oggetti non allocati
            if item.quantitaAllocata < item.quantitaInViaggio{
                let newallocazione = self.addOggettoInValigia(oggetto: item, valigia: nonallocati, viaggio: viaggio)
                let quantitaMancante: Int = Int(item.quantitaInViaggio - item.quantitaAllocata)
                newallocazione.quantitaInValigia = Int32(quantitaMancante) //metto nei non allocati la quantità mancante
                nonallocati.addToContenuto(newallocazione)
                nonallocati.volumeAttuale += Int32(quantitaMancante) * (item.oggettoRef?.volume ?? 0)
                nonallocati.pesoAttuale += Int32(quantitaMancante) * (item.oggettoRef?.peso ?? 0)
            }

            
        }
        
    }
    
    
    //funzione si supporto alla allocazione per volume
    func allocaPerVolume(bins: [ValigiaViaggiante], elements: [OggettoViaggiante], nonallocati: ValigiaViaggiante, viaggio: Viaggio){
        //ordino gli oggetti in maniera decrescente di priorità di inserimento. Assumo che la priorità sia dettata dal volume
        let descendingelements: [OggettoViaggiante] = elements.sorted(by: {$0.oggettoRef?.volume ?? 0 > $1.oggettoRef?.volume ?? 0})
        
        //Calcolo secondo volume
        for item in descendingelements{
            item.quantitaAllocata = 0 //reinizializzo
            
            
            
            for i in bins.indices{
            
                //calcolo quante occorrenze di questo item possono essere inserite nel bin attuale e le inserisco
                let volumedisponibile = Int(bins[i].volumeMassimo - bins[i].volumeAttuale)
            
                let numItemContenibili = Int(volumedisponibile/Int((item.oggettoRef?.volume ?? 1)))
            
                if numItemContenibili > 0{//significa che almeno uno lo posso inserire
                    
                    //controllo se nel bin attuale vi è già un oggetto in valigia che si riferisce all'oggetto viaggiante in questione (item)
                    let existing: [OggettoInValigia] = loadOggettiInValigiaFromValigiaOggetto(valigiaV: bins[i], oggettoV: item)
                    var allocabili = 0
                    
                    if numItemContenibili >= (item.quantitaInViaggio - item.quantitaAllocata){
                        //li posso inserire tutti li inserisco tutti
                        
                        allocabili = Int(item.quantitaInViaggio - item.quantitaAllocata) //alloco quelli che mancano per allocarli tutti
                        
                        
                    }else{//maggiore di 0 ma non posso inserire tutta la quantità dell'item
                        
                        allocabili = numItemContenibili //alloco il possibile
                        
                    }
                    
                    
                    if allocabili != 0{
                        if existing.count > 0{//se esiste già un oggettoinvaligia con quell'item
                    
                            item.quantitaAllocata += Int32(allocabili)
                            existing[0].quantitaInValigia += Int32(allocabili)
                        }else{//nesssun oggetto precedentemente allocato
                            let newallocazione: OggettoInValigia = self.addOggettoInValigia(oggetto: item, valigia: bins[i], viaggio: viaggio)
                            newallocazione.quantitaInValigia = Int32(allocabili)
                            bins[i].addToContenuto(newallocazione)
                            item.quantitaAllocata += Int32(allocabili)
                        }
                        bins[i].volumeAttuale += Int32(allocabili) * (item.oggettoRef?.volume ?? 0)
                        bins[i].pesoAttuale += Int32(allocabili) * (item.oggettoRef?.peso ?? 0)
                    }

                    if item.quantitaAllocata == item.quantitaInViaggio {//se ho allocato tutta la quantità dell'oggetto allora posso evitre di vedere altre valigie
                        break
                    }
                    
                    
                }else{
                    print("Non posso inserire nessun \(item.oggettoRef?.nome ?? "Nome oggetto") nella valigia \(bins[i].valigiaRef?.nome ?? "Nome valigia")")
                }//else -> in questo bin non c'è spazio per nessuna quantità di questo item
                
            }//quando esco dal for potrei aver allocato tutte le quantita dei miei oggetti oppure avere oggetti con quantitallocata<quantitainviaggio
            
            
            //Se dopo aver girato tutti i bins non ho allocato tutte le occorrenze del mio oggetto sono costretto a metterlo negli oggetti non allocati
            if item.quantitaAllocata < item.quantitaInViaggio{
                let newallocazione = self.addOggettoInValigia(oggetto: item, valigia: nonallocati, viaggio: viaggio)
                let quantitaMancante: Int = Int(item.quantitaInViaggio - item.quantitaAllocata)
                newallocazione.quantitaInValigia = Int32(quantitaMancante) //metto nei non allocati la quantità mancante
                nonallocati.addToContenuto(newallocazione)
                nonallocati.volumeAttuale += Int32(quantitaMancante) * (item.oggettoRef?.volume ?? 0)
                nonallocati.pesoAttuale += Int32(quantitaMancante) * (item.oggettoRef?.peso ?? 0)
            }

            
        }
        
        
    }
    
    //funzione che controlla se esiste già un riferiemnto all'oggetto fisico nel viaggio. in tal caso ne aumenta la quantità e ritorna true, altrimenti ritorna false
    func checkExistingOggettoInViaggio(oggetto: Oggetto, viaggio: Viaggio) -> Bool{
        let oggettiViaggio = self.loadOggettiViaggiantiFromViaggio(viaggioRef: viaggio)
        var contain: Bool = false
        contain = oggettiViaggio.contains{
            oggv in
            
            if oggv.oggettoRef?.id == oggetto.id {
                return true
            }else{
                return false
            }
            
        }
        if contain{
            //devo trovarlo e aumentare la quantità
            
            for ogg in self.loadOggettiViaggiantiFromViaggio(viaggioRef: viaggio){
                if ogg.oggettoRef?.id == oggetto.id{
                    ogg.quantitaInViaggio = ogg.quantitaInViaggio + 1
                    self.saveContext()
                    break
                }
            }
        }
        
        return contain
    }
    
    func resetDatabase(){
        //elimino tutte le dipendenze degli oggetti e delle valigie che andrò a cancellare
        let viaggi = self.loadAllViaggi()
        for viaggio in viaggi{
            //elimino tutti gli oggetti in valigia
            self.deleteOggettiInValigia(viaggio: viaggio)
            //elimino tutti gli oggetti viaggianti
            self.deleteAllOggettoViaggiante(viaggio: viaggio)
            //elimino tutte le valigie viaggianti
            self.deleteAllValigiaViaggiante(viaggio: viaggio)
        }
        //eliminare tutti gli oggetti
        self.deleteAllOggetti()
        //eliminare tutte le valigie
        self.deleteAllValigie()
        
        //reinizializzo
        self.inizializzaValigie()
        self.inizializzaOggetti()
    }
    
    func deleteAllOggettiPersonalizzati(){
        
        let request: NSFetchRequest <Oggetto> = NSFetchRequest(entityName: "Oggetto")
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "nome MATCHES '.*★'")
        request.predicate = predicate
        
        let oggetti = self.loadOggettiFromFetchRequest(request:request)
        
        print("NUMERO DI OGGETTI PERSONALIZZTI TROVATI: \(oggetti.count)")
        for oggetto in oggetti {
            print("Cerco di eliminare \(oggetto.nome ?? "")")
            self.deleteOggetto(nome: oggetto.nome ?? "", categoria: oggetto.categoria ?? "")
        }
        
        self.saveContext()
    }
    
    func inizializzaOggetti(){
        
        //Categoria 1
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 4, lunghezza: 11, profondita: 5, peso: 280, nome: "Profumo")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 5, lunghezza: 18, profondita: 5, peso: 120, nome: "Deodorante")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 7, lunghezza: 19, profondita: 2, peso: 350, nome: "Bagnoschiuma")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 1, lunghezza: 5, profondita: 1, peso: 10, nome: "Cotton fioc")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 4, lunghezza: 19, profondita: 2, peso: 90, nome: "Dentifricio")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 6, lunghezza: 6, profondita: 18, peso: 380, nome: "Gel da barba")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 4, lunghezza: 15, profondita: 4, peso: 40, nome: "Lenti a contatto")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 1, lunghezza: 1, profondita: 1, peso: 20, nome: "Pinzetta")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 3, lunghezza: 17, profondita: 2, peso: 130, nome: "Rasoio")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 2, lunghezza: 21, profondita: 2, peso: 120, nome: "Spazzolino")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 4, lunghezza: 24, profondita: 4, peso: 85, nome: "Spazzola")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 1, lunghezza: 1, profondita: 1, peso: 20, nome: "Tagliaunghie")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 16, lunghezza: 21, profondita: 7, peso: 600, nome: "Trucchi")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 8, lunghezza: 8, profondita: 4, peso: 120, nome: "Gel per capelli")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 5, lunghezza: 24, profondita: 5, peso: 200, nome: "Lacca")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 10, lunghezza: 26, profondita: 3, peso: 545, nome: "Colluttorio")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 7, lunghezza: 29, profondita: 2, peso: 200, nome: "Pantofole")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Articoli da bagno", larghezza: 19, lunghezza: 26, profondita: 6, peso: 400, nome: "Accappatoio")//Misurato
        //Categoria 2
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 7, lunghezza: 11, profondita: 4, peso: 60, nome: "Biancheria Intima")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 7, lunghezza: 9, profondita: 3, peso: 25, nome: "Calzini")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 13, lunghezza: 14, profondita: 4, peso: 180, nome: "T-Shirt")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 18, lunghezza: 20, profondita: 5, peso: 350, nome: "Maglioncino")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 17, lunghezza: 32, profondita: 13, peso: 700, nome: "Maglione")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 19, lunghezza: 24, profondita: 7, peso: 530, nome: "Giacca")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 29, lunghezza: 40, profondita: 6, peso: 1000, nome: "Cappotto")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 24, lunghezza: 30, profondita: 8, peso: 600, nome: "Giubbino")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 17, lunghezza: 27, profondita: 6, peso: 630, nome: "Pantalone")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 14, lunghezza: 28, profondita: 4, peso: 430, nome: "Pantaloncino")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 19, lunghezza: 21, profondita: 2, peso: 180, nome: "Camicia")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 13, lunghezza: 14, profondita: 8, peso: 400, nome: "Pigiama")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 12, lunghezza: 30, profondita: 22, peso: 950, nome: "Scarpe")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 22, lunghezza: 24, profondita: 10, peso: 620, nome: "Felpa")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 9, lunghezza: 17, profondita: 4, peso: 110, nome: "Calze")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Abbigliamento", larghezza: 7, lunghezza: 28, profondita: 7, peso: 200, nome: "Leggins")//Misurato
        //Categoria 3
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 5, lunghezza: 11, profondita: 2, peso: 30, nome: "Farmaci")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 7, lunghezza: 11, profondita: 3, peso: 190, nome: "Cintura")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 3, lunghezza: 8, profondita: 2, peso: 100, nome: "Chiavi di casa")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 5, lunghezza: 15, profondita: 1, peso: 5, nome: "Mascherina")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 5, lunghezza: 16, profondita: 2, peso: 140, nome: "Occhiali")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 3, lunghezza: 6, profondita: 2, peso: 25, nome: "Orologio")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 8, lunghezza: 10, profondita: 3, peso: 180, nome: "Portafoglio")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 8, lunghezza: 10, profondita: 1, peso: 20, nome: "Passaporto")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 1, lunghezza: 6, profondita: 1, peso: 5, nome: "Penna")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 0, lunghezza: 0, profondita: 0, peso: 0, nome: "Documenti di identità")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 3, lunghezza: 5, profondita: 1, peso: 70, nome: "Lucchetto")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 5, lunghezza: 16, profondita: 2, peso: 140, nome: "Occhiali da sole")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 5, lunghezza: 20, profondita: 5, peso: 520, nome: "Bottiglia 500ml")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 4, lunghezza: 12, profondita: 4, peso: 30, nome: "Apribottiglie")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 2, lunghezza: 8, profondita: 1, peso: 15, nome: "Accendino")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 7, lunghezza: 24, profondita: 7, peso: 800, nome: "Borraccia 500ml")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 5, lunghezza: 30, profondita: 5, peso: 500, nome: "Ombrello")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 13, lunghezza: 20, profondita: 2, peso: 220, nome: "Libro")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Essenziali", larghezza: 5, lunghezza: 9, profondita: 2, peso: 70, nome: "Carte")//Misurato
        //Categoria 4
        PersistenceManager.shared.addOggetto(categoria: "Campeggio", larghezza: 6, lunghezza: 20, profondita: 6, peso: 350, nome: "Buste di plastica")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Campeggio", larghezza: 12, lunghezza: 10, profondita: 12, peso: 160, nome: "Carta Igienica")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Campeggio", larghezza: 3, lunghezza: 8, profondita: 2, peso: 100, nome: "Coltello mutliuso")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Campeggio", larghezza: 40, lunghezza: 40, profondita: 8, peso: 800, nome: "Cuscino")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Campeggio", larghezza: 4, lunghezza: 14, profondita: 4, peso: 170, nome: "Torcia")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Campeggio", larghezza: 2, lunghezza: 20, profondita: 2, peso: 125, nome: "Posate")//Misurato
        //Categoria 5
        PersistenceManager.shared.addOggetto(categoria: "Spiaggia", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Borsa da spiaggia")
        PersistenceManager.shared.addOggetto(categoria: "Spiaggia", larghezza: 10, lunghezza: 20, profondita: 5, peso: 10, nome: "Cappello")
        PersistenceManager.shared.addOggetto(categoria: "Spiaggia", larghezza: 16, lunghezza: 20, profondita: 2, peso: 130, nome: "Costume")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Spiaggia", larghezza: 7, lunghezza: 19, profondita: 2, peso: 350, nome: "Protezione Solare")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Spiaggia", larghezza: 7, lunghezza: 19, profondita: 2, peso: 350, nome: "Doposole")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Spiaggia", larghezza: 13, lunghezza: 21, profondita: 3, peso: 240, nome: "Telo mare")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Spiaggia", larghezza: 5, lunghezza: 15, profondita: 3, peso: 35, nome: "Occhialini")//Misurato
        //Categoria 6
        PersistenceManager.shared.addOggetto(categoria: "Sport", larghezza: 9, lunghezza: 17, profondita: 4, peso: 110, nome: "T-shirt da palestra")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Sport", larghezza: 20, lunghezza: 24, profondita: 4, peso: 400, nome: "Felpa tuta")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Sport", larghezza: 14, lunghezza: 23, profondita: 6, peso: 300, nome: "Pantaloni tuta")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Sport", larghezza: 7, lunghezza: 7, profondita: 28, peso: 200, nome: "Pantaloncini tuta")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Sport", larghezza: 12, lunghezza: 30, profondita: 19, peso: 800, nome: "Scarpe da ginnastica")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Sport", larghezza: 12, lunghezza: 30, profondita: 26, peso: 1200, nome: "Scarpe da trekking")//Misurato
        //Categoria 7
        PersistenceManager.shared.addOggetto(categoria: "Informatica ed Elettronica", larghezza: 5, lunghezza: 5, profondita: 5, peso: 100, nome: "Caricatore")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Informatica ed Elettronica", larghezza: 10, lunghezza: 13, profondita: 11, peso: 650, nome: "Fotocamera")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Informatica ed Elettronica", larghezza: 17, lunghezza: 19, profondita: 4, peso: 400, nome: "Cuffie")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Informatica ed Elettronica", larghezza: 4, lunghezza: 5, profondita: 2, peso: 45, nome: "Auricolari")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Informatica ed Elettronica", larghezza: 23, lunghezza: 33, profondita: 3, peso: 1600, nome: "Laptop")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Informatica ed Elettronica", larghezza: 3, lunghezza: 6, profondita: 2, peso: 25, nome: "Smartwatch")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Informatica ed Elettronica", larghezza: 6, lunghezza: 16, profondita: 2, peso: 300, nome: "Powerbank")//Misurato
        PersistenceManager.shared.addOggetto(categoria: "Informatica ed Elettronica", larghezza: 12, lunghezza: 14, profondita: 2, peso: 300, nome: "Cacciaviti")//Misurato
    }

    func inizializzaValigie(){
        PersistenceManager.shared.addValigia(categoria: "Zaino", lunghezza: 40, larghezza: 20, profondita: 13, nome: "Zaino", tara: 900, utilizzato: false)
        
        PersistenceManager.shared.addValigia(categoria: "Bagaglio a mano", lunghezza: 40, larghezza: 25, profondita: 20, nome: "Bagaglio a mano", tara: 2700, utilizzato: false)
        
        PersistenceManager.shared.addValigia(categoria: "Bagaglio da stiva", lunghezza: 77, larghezza: 50, profondita: 31, nome: "Bagaglio da stiva", tara: 4500, utilizzato: false)
        
        
        PersistenceManager.shared.addValigia(categoria: "0SYSTEM", lunghezza: 0, larghezza: 0, profondita: 0, nome: "Non Allocati", tara: 0, utilizzato: false)
    }

}

