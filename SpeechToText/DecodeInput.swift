//
//  DecodeInput.swift
//  tirocinio
//
//  Created by Grazia Ferrara on 12/06/22.
//

import Foundation

public class DecodeInput {
    
    public static var oggetti = [(name:String, category:String)]()
    
    public func searchIntoCollection(){
        DecodeInput.oggetti.removeAll()
        let allObjects = PersistenceManager.shared.loadAllOggetti()
        allObjects.forEach{ object in
            DecodeInput.oggetti.append((name: object.nome!, category:object.categoria!))
        }
    }
    
    public func decode(text: String, viaggioNome: String) -> Bool {
        
        // metto tutti gli oggetti disponibili all'interno dell'array oggetti
        searchIntoCollection()
        
        // permette di splittare una stringa ed inserire le parole di cui è composta
        // all'interno di un array
        let azione : String = text.components(separatedBy: " ")[0].lowercased()
        var done = false
        
        // verifico l'azione da compiere
        switch azione {
            
            case "aggiungi", "inserisci", "metti":
            
                // verifico se l'oggetto da inserire è effettivamente un oggetto
                for item in DecodeInput.oggetti {
                    if(text.lowercased().contains(item.name.lowercased())){
                        let oggetto = PersistenceManager.shared.loadOggettiFromNomeCategoria(nome: item.name, categoria: item.category)[0]
                        let viaggio = PersistenceManager.shared.loadViaggiFromNome(nome: viaggioNome)[0]
                        PersistenceManager.shared.addOggettoViaggiante(oggetto: oggetto, viaggio: viaggio)
                        done = true
                    }
                }
            
                // se non sono stati trovati oggetti verifico se si tratta di una valigia da inserire
                
            case "rimuovi", "togli", "elimina":
            
                // verifico se l'oggetto da eliminare è effettivamente un oggetto
                for item in DecodeInput.oggetti {
                    if(text.lowercased().contains(item.name.lowercased())){
                        let oggetto = PersistenceManager.shared.loadOggettiFromNomeCategoria(nome: item.name, categoria: item.category)[0]
                        let viaggio = PersistenceManager.shared.loadViaggiFromNome(nome: viaggioNome)[0]
                        PersistenceManager.shared.deleteOggettoViaggiante(ogetto: oggetto, viaggio: viaggio)
                        done = true
                    }
                }
            
                // se non sono stati trovati oggetti, verifico se si tratta di una valigia da eliminare
            
                
            default:
            
                // l'azione da compiere non è aggiunta o rimozione di oggetti / valigie
                done = false
            
        }
        
        return done
    }
    
}
