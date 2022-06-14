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
        searchIntoCollection()
        for item in DecodeInput.oggetti {
            if(text.lowercased() == "aggiungi \(item.name.lowercased())"){
                let oggetto = PersistenceManager.shared.loadOggettiFromNomeCategoria(nome: item.name, categoria: item.category)[0]
                let viaggio = PersistenceManager.shared.loadViaggiFromNome(nome: viaggioNome)[0]
                PersistenceManager.shared.addOggettoViaggiante(oggetto: oggetto, viaggio: viaggio)
                return true
            }
        }
        return false
    }
    
}
