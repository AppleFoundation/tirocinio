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
    
    public func decode(text: String) -> Bool {
        var found = false
        searchIntoCollection()
        DecodeInput.oggetti.forEach{ item in
            if(text.lowercased() == "aggiungi \(item.name.lowercased())"){
                PersistenceManager.shared.addOggetto(categoria: item.category, larghezza: 10, lunghezza: 20, profondita: 5, peso: 500, nome: item.name)
                let oggetto = PersistenceManager.shared.loadOggettiFromNomeCategoria(nome: item.name, categoria: item.category)[0]
                let viaggio = PersistenceManager.shared.loadAllViaggi()[0]
                PersistenceManager.shared.addOggettoViaggiante(oggetto: oggetto, viaggio: viaggio)
                found = true
            }
        }
        return found
    }
    
}
